// 轻量 XLSX 写入器：只做「按行改单元格数值」这件事
// 不依赖第三方库：自己解 ZIP → 改 sheet xml → 重新打包 ZIP（保留其余条目原样）
const fs = require('fs');
const path = require('path');
const zlib = require('zlib');

// ---------- CRC32 ----------
const CRC_TABLE = (() => {
    const t = new Int32Array(256);
    for (let n = 0; n < 256; n++) {
        let c = n;
        for (let k = 0; k < 8; k++) c = c & 1 ? 0xEDB88320 ^ (c >>> 1) : c >>> 1;
        t[n] = c;
    }
    return t;
})();

function crc32(buf) {
    let c = 0 ^ (-1);
    for (let i = 0; i < buf.length; i++) c = (c >>> 8) ^ CRC_TABLE[(c ^ buf[i]) & 0xFF];
    return (c ^ (-1)) >>> 0;
}

function decodeXml(s) {
    return String(s)
        .replace(/&#x([0-9a-fA-F]+);/g, (_, h) => String.fromCodePoint(parseInt(h, 16)))
        .replace(/&#(\d+);/g, (_, d) => String.fromCodePoint(parseInt(d, 10)))
        .replace(/&lt;/g, '<').replace(/&gt;/g, '>')
        .replace(/&quot;/g, '"').replace(/&apos;/g, "'")
        .replace(/&amp;/g, '&');
}

// ---------- 读 ZIP ----------
function readZip(buf) {
    let eocd = -1;
    for (let i = buf.length - 22; i >= 0; i--) {
        if (buf.readUInt32LE(i) === 0x06054b50) { eocd = i; break; }
    }
    if (eocd < 0) throw new Error('不是有效的 xlsx/zip 文件');

    const cdCount = buf.readUInt16LE(eocd + 10);
    const cdOffset = buf.readUInt32LE(eocd + 16);

    const order = [];
    const entries = new Map();
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

        const off = localOffset;
        if (buf.readUInt32LE(off) !== 0x04034b50) throw new Error('本地文件头损坏: ' + name);
        const lNameLen = buf.readUInt16LE(off + 26);
        const lExtraLen = buf.readUInt16LE(off + 28);
        const dataStart = off + 30 + lNameLen + lExtraLen;
        const comp = buf.subarray(dataStart, dataStart + compSize);
        const data = method === 0 ? Buffer.from(comp) : zlib.inflateRawSync(comp);

        order.push(name);
        entries.set(name, data);
        p += 46 + nameLen + extraLen + commentLen;
    }
    return { order, entries };
}

// ---------- 写 ZIP ----------
function dosDateTime(d) {
    const time = ((d.getHours() & 0x1f) << 11) | ((d.getMinutes() & 0x3f) << 5) | ((d.getSeconds() >> 1) & 0x1f);
    const date = (((d.getFullYear() - 1980) & 0x7f) << 9) | (((d.getMonth() + 1) & 0x0f) << 5) | (d.getDate() & 0x1f);
    return { time: time & 0xffff, date: date & 0xffff };
}

function buildZip(order, entries) {
    const now = dosDateTime(new Date());
    const localParts = [];
    const centralParts = [];
    let offset = 0;
    let count = 0;

    for (const name of order) {
        const data = entries.get(name) || Buffer.alloc(0);
        const nameBuf = Buffer.from(name, 'utf8');
        const crc = crc32(data);
        // 空条目（目录）用 store，其余用 deflate
        const method = data.length === 0 ? 0 : 8;
        const comp = method === 0 ? data : zlib.deflateRawSync(data, { level: 9 });

        const lh = Buffer.alloc(30);
        lh.writeUInt32LE(0x04034b50, 0);
        lh.writeUInt16LE(20, 4);
        lh.writeUInt16LE(0x0800, 6);       // UTF-8 文件名
        lh.writeUInt16LE(method, 8);
        lh.writeUInt16LE(now.time, 10);
        lh.writeUInt16LE(now.date, 12);
        lh.writeUInt32LE(crc, 14);
        lh.writeUInt32LE(comp.length, 18);
        lh.writeUInt32LE(data.length, 22);
        lh.writeUInt16LE(nameBuf.length, 26);
        lh.writeUInt16LE(0, 28);
        localParts.push(lh, nameBuf, comp);

        const ch = Buffer.alloc(46);
        ch.writeUInt32LE(0x02014b50, 0);
        ch.writeUInt16LE(20, 4);           // version made by
        ch.writeUInt16LE(20, 6);           // version needed
        ch.writeUInt16LE(0x0800, 8);
        ch.writeUInt16LE(method, 10);
        ch.writeUInt16LE(now.time, 12);
        ch.writeUInt16LE(now.date, 14);
        ch.writeUInt32LE(crc, 16);
        ch.writeUInt32LE(comp.length, 20);
        ch.writeUInt32LE(data.length, 24);
        ch.writeUInt16LE(nameBuf.length, 28);
        ch.writeUInt16LE(0, 30);
        ch.writeUInt16LE(0, 32);
        ch.writeUInt16LE(0, 34);
        ch.writeUInt16LE(0, 36);
        ch.writeUInt32LE(0, 38);
        ch.writeUInt32LE(offset, 42);
        centralParts.push(ch, nameBuf);

        offset += lh.length + nameBuf.length + comp.length;
        count++;
    }

    const cd = Buffer.concat(centralParts);
    const eocd = Buffer.alloc(22);
    eocd.writeUInt32LE(0x06054b50, 0);
    eocd.writeUInt16LE(0, 4);
    eocd.writeUInt16LE(0, 6);
    eocd.writeUInt16LE(count, 8);
    eocd.writeUInt16LE(count, 10);
    eocd.writeUInt32LE(cd.length, 12);
    eocd.writeUInt32LE(offset, 16);
    eocd.writeUInt16LE(0, 20);

    return Buffer.concat([...localParts, cd, eocd]);
}

// ---------- 找 sheet 对应的 xml 文件 ----------
function getSheetFile(entries, sheetName) {
    const wbBuf = entries.get('xl/workbook.xml');
    if (!wbBuf) throw new Error('缺少 xl/workbook.xml');
    const wbXml = wbBuf.toString('utf8');

    let rid = null;
    for (const m of wbXml.matchAll(/<sheet\b[^>]*\/>/g)) {
        const tag = m[0];
        const nameM = tag.match(/\bname="([^"]*)"/);
        if (!nameM) continue;
        if (decodeXml(nameM[1]) !== sheetName) continue;
        const r = tag.match(/\br:id="([^"]*)"/);
        if (r) rid = r[1];
        break;
    }
    if (!rid) return null;

    const relsBuf = entries.get('xl/_rels/workbook.xml.rels');
    if (!relsBuf) throw new Error('缺少 xl/_rels/workbook.xml.rels');
    const relsXml = relsBuf.toString('utf8');

    for (const m of relsXml.matchAll(/<Relationship\b[^>]*\/>/g)) {
        const rel = m[0];
        if (!new RegExp(`\\bId="${rid}"`).test(rel)) continue;
        const t = rel.match(/\bTarget="([^"]*)"/);
        if (!t) break;
        let target = t[1];
        target = target.replace(/^\/?xl\//, '').replace(/^\//, '');
        return 'xl/' + target;
    }
    return null;
}

// ---------- 单元格写入 ----------
function colLetterToNum(letters) {
    let n = 0;
    for (const ch of letters) n = n * 26 + (ch.charCodeAt(0) - 64);
    return n - 1;
}

function numToColLetter(n) {
    // n 从 0 开始：0 -> A
    let s = '';
    let x = n + 1;
    while (x > 0) {
        const r = (x - 1) % 26;
        s = String.fromCharCode(65 + r) + s;
        x = Math.floor((x - 1) / 26);
    }
    return s;
}

// 在 sheet xml 中写入某个单元格的数值，保留原有样式 s
function upsertNumericCell(xml, rowNum, colLetter, valueText) {
    const ref = colLetter + rowNum;
    const rowRe = new RegExp(`<row\\b[^>]*\\br="${rowNum}"[^>]*>[\\s\\S]*?</row>`);
    const rowMatch = xml.match(rowRe);
    if (!rowMatch) return { xml, ok: false, reason: `第 ${rowNum} 行不存在` };

    const fullRow = rowMatch[0];
    const innerStartInRow = fullRow.indexOf('>') + 1;
    const innerEndInRow = fullRow.lastIndexOf('</row>');
    const inner = fullRow.slice(innerStartInRow, innerEndInRow);

    const cellRe = new RegExp(`<c\\b([^>]*?\\br="${ref}"[^>]*?)(?:/>|>[\\s\\S]*?</c>)`);
    const cellMatch = inner.match(cellRe);

    let newInner;
    if (cellMatch) {
        // 保留除 t 以外的属性（t="s" 之类要去掉，因为改成数值了）
        const attrs = cellMatch[1].replace(/\s+t="[^"]*"/g, '');
        newInner = inner.replace(cellMatch[0], `<c${attrs}><v>${valueText}</v></c>`);
    } else {
        // 单元格不存在：按列顺序插入
        const targetCol = colLetterToNum(colLetter);
        let insertAt = inner.length;
        const anyCellRe = /<c\b([^>]*?)(?:\/>|>[\s\S]*?<\/c>)/g;
        let mm;
        while ((mm = anyCellRe.exec(inner))) {
            const rM = mm[1].match(/\br="([A-Z]+)\d+"/);
            if (!rM) continue;
            if (colLetterToNum(rM[1]) > targetCol) { insertAt = mm.index; break; }
        }
        const newCell = `<c r="${ref}"><v>${valueText}</v></c>`;
        newInner = inner.slice(0, insertAt) + newCell + inner.slice(insertAt);
    }

    const newRow = fullRow.slice(0, innerStartInRow) + newInner + fullRow.slice(innerEndInRow);
    const idx = rowMatch.index;
    return { xml: xml.slice(0, idx) + newRow + xml.slice(idx + fullRow.length), ok: true };
}

function formatNumber(v) {
    const n = typeof v === 'number' ? v : parseFloat(v);
    if (!isFinite(n)) return null;
    // 去掉多余的 0，避免 1.2300000000000002 这类浮点尾巴
    const s = String(Number(n.toFixed(6)));
    return s;
}

/**
 * 修改某个 sheet 里若干单元格的数值
 * @param {string} filePath  xlsx 路径
 * @param {string} sheetName sheet 名（如 'Sheet1'）
 * @param {Array<{row:number,col:string,value:number|string}>} cells  row 为 Excel 的 1 基行号，col 为列字母
 * @returns {{updated:number, backupPath:string, warnings:string[]}}
 */
function updateCells(filePath, sheetName, cells) {
    const buf = fs.readFileSync(filePath);
    const { order, entries } = readZip(buf);

    const sheetFile = getSheetFile(entries, sheetName);
    if (!sheetFile || !entries.has(sheetFile)) {
        throw new Error(`模板中未找到 sheet: ${sheetName}`);
    }

    let xml = entries.get(sheetFile).toString('utf8');
    const warnings = [];
    let updated = 0;

    for (const cell of cells) {
        const valueText = formatNumber(cell.value);
        if (valueText === null) {
            warnings.push(`第 ${cell.row} 行 ${cell.col} 列的值不是有效数字，已跳过`);
            continue;
        }
        const r = upsertNumericCell(xml, cell.row, cell.col, valueText);
        if (r.ok) {
            xml = r.xml;
            updated++;
        } else {
            warnings.push(r.reason);
        }
    }

    entries.set(sheetFile, Buffer.from(xml, 'utf8'));
    const out = buildZip(order, entries);

    // 备份原文件，方便回滚
    const backupDir = path.join(__dirname, '..', '.workbuddy', 'backups');
    fs.mkdirSync(backupDir, { recursive: true });
    const stamp = new Date().toISOString().replace(/[:.]/g, '-');
    const backupPath = path.join(backupDir, `moban-${stamp}.xlsx`);
    fs.copyFileSync(filePath, backupPath);

    // 先写临时文件再替换，避免写一半损坏
    const tmpPath = filePath + '.tmp';
    fs.writeFileSync(tmpPath, out);
    fs.renameSync(tmpPath, filePath);

    return { updated, backupPath, warnings };
}

module.exports = { updateCells, numToColLetter };
