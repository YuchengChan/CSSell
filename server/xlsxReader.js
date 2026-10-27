// 轻量 XLSX 读取器（无第三方依赖，使用 Node 内置 zlib 解压 ZIP）
// 导出 readXlsx(filePath) => { sheetNames: [], sheets: [{ name, rows: [[...]] }] }
const fs = require('fs');
const zlib = require('zlib');

function decodeXml(s) {
    return s
        .replace(/&#x([0-9a-fA-F]+);/g, (_, h) => String.fromCodePoint(parseInt(h, 16)))
        .replace(/&#(\d+);/g, (_, d) => String.fromCodePoint(parseInt(d, 10)))
        .replace(/&lt;/g, '<').replace(/&gt;/g, '>')
        .replace(/&quot;/g, '"').replace(/&apos;/g, "'")
        .replace(/&amp;/g, '&');
}

function allText(inner) {
    let t = '';
    const re = /<t[^>]*>([\s\S]*?)<\/t>/g;
    let m;
    while ((m = re.exec(inner))) t += decodeXml(m[1]);
    return t;
}

function colToNum(ref) {
    const letters = (ref.match(/[A-Z]+/) || ['A'])[0];
    let n = 0;
    for (const ch of letters) n = n * 26 + (ch.charCodeAt(0) - 64);
    return n - 1;
}

function parseSheetXml(xml, shared) {
    const rows = [];
    const rowRe = /<row[^>]*r="(\d+)"[^>]*>([\s\S]*?)<\/row>/g;
    let rm;
    while ((rm = rowRe.exec(xml))) {
        const rowIdx = parseInt(rm[1], 10) - 1;
        const cellsXml = rm[2];
        const cells = [];
        const cRe = /<c\b([^>]*?)\/>|<c\b([^>]*?)>([\s\S]*?)<\/c>/g;
        let cm;
        while ((cm = cRe.exec(cellsXml))) {
            const attrs = cm[1] || cm[2] || '';
            const innerXml = cm[3] || '';
            const refM = attrs.match(/r="([A-Z]+\d+)"/);
            const tM = attrs.match(/\bt="([^"]+)"/);
            const col = refM ? colToNum(refM[1]) : cells.length;
            const t = tM ? tM[1] : null;
            let val = '';
            if (t === 's') {
                const v = innerXml.match(/<v>([\s\S]*?)<\/v>/);
                if (v) val = shared[parseInt(v[1], 10)] ?? '';
            } else if (t === 'inlineStr') {
                const is = innerXml.match(/<is>([\s\S]*?)<\/is>/);
                if (is) val = allText(is[1]);
            } else if (t === 'str') {
                const v = innerXml.match(/<v>([\s\S]*?)<\/v>/);
                if (v) val = decodeXml(v[1]);
            } else {
                const v = innerXml.match(/<v>([\s\S]*?)<\/v>/);
                if (v) val = v[1];
            }
            cells[col] = val;
        }
        for (let i = 0; i < cells.length; i++) if (cells[i] === undefined) cells[i] = '';
        rows[rowIdx] = cells;
    }
    for (let i = 0; i < rows.length; i++) if (!rows[i]) rows[i] = [];
    return rows;
}

function readXlsx(filePath) {
    const buf = fs.readFileSync(filePath);

    // 定位 ZIP 的 EOCD
    let eocd = -1;
    for (let i = buf.length - 22; i >= 0; i--) {
        if (buf.readUInt32LE(i) === 0x06054b50) { eocd = i; break; }
    }
    if (eocd < 0) throw new Error('不是有效的 xlsx/zip 文件');

    const cdCount = buf.readUInt16LE(eocd + 10);
    const cdOffset = buf.readUInt32LE(eocd + 16);

    const entries = {};
    let p = cdOffset;
    for (let i = 0; i < cdCount; i++) {
        if (buf.readUInt32LE(p) !== 0x02014b50) break;
        const method = buf.readUInt16LE(p + 10);
        const compSize = buf.readUInt32LE(p + 20);
        const nameLen = buf.readUInt16LE(p + 28);
        const extraLen = buf.readUInt16LE(p + 30);
        const commentLen = buf.readUInt16LE(p + 32);
        const localOffset = buf.readUInt32LE(p + 42);
        const name = buf.toString('utf8', p + 46, p + 46 + nameLen);
        entries[name] = { method, compSize, localOffset };
        p += 46 + nameLen + extraLen + commentLen;
    }

    function extract(name) {
        const e = entries[name];
        if (!e) return null;
        const off = e.localOffset;
        if (buf.readUInt32LE(off) !== 0x04034b50) throw new Error('本地文件头损坏: ' + name);
        const nameLen = buf.readUInt16LE(off + 26);
        const extraLen = buf.readUInt16LE(off + 28);
        const dataStart = off + 30 + nameLen + extraLen;
        const comp = buf.subarray(dataStart, dataStart + e.compSize);
        return e.method === 0 ? comp : zlib.inflateRawSync(comp);
    }

    // 共享字符串
    const shared = [];
    const sharedXml = extract('xl/sharedStrings.xml');
    if (sharedXml) {
        const xml = sharedXml.toString('utf8');
        const re = /<si>([\s\S]*?)<\/si>/g;
        let m;
        while ((m = re.exec(xml))) shared.push(allText(m[1]));
    }

    // sheet 名称
    const sheetNames = [];
    const wb = extract('xl/workbook.xml');
    if (wb) {
        const xml = wb.toString('utf8');
        const re = /<sheet\b[^>]*name="([^"]*)"[^>]*\/>/g;
        let m;
        while ((m = re.exec(xml))) sheetNames.push(decodeXml(m[1]));
    }

    const sheetFiles = Object.keys(entries)
        .filter(n => /^xl\/worksheets\/sheet\d+\.xml$/.test(n))
        .sort((a, b) => parseInt(a.match(/(\d+)\.xml$/)[1], 10) - parseInt(b.match(/(\d+)\.xml$/)[1], 10));

    const sheets = sheetFiles.map((f, idx) => ({
        name: sheetNames[idx] || f,
        rows: parseSheetXml(extract(f).toString('utf8'), shared)
    }));

    return { sheetNames, sheets };
}

module.exports = { readXlsx };
