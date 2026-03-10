const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
require('dotenv').config({ path: './.env' });

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Build database config dynamically to handle empty password
console.log('DB_USER:', process.env.DB_USER);  // Debug log
console.log('DB_PASSWORD:', process.env.DB_PASSWORD);  // Debug log
console.log('DB_HOST:', process.env.DB_HOST);  // Debug log
console.log('DB_NAME:', process.env.DB_NAME);  // Debug log

let dbConfig = {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT || 3306,
    user: process.env.DB_USER,
    database: process.env.DB_NAME
};

// Only add password if it's not empty
if (process.env.DB_PASSWORD && process.env.DB_PASSWORD.trim() !== '') {
    dbConfig.password = process.env.DB_PASSWORD;
}

async function createConnection() {
    try {
        const connection = await mysql.createConnection(dbConfig);
        console.log('数据库连接成功');
        return connection;
    } catch (error) {
        console.error('数据库连接失败:', error);
        throw error;
    }
}

async function createTokenTables() {
    try {
        const connection = await createConnection();
        
        // 创建bufftoken表（只有buffToken字段）
        const createBuffTokenTableSQL = `
            CREATE TABLE IF NOT EXISTS bufftoken (
                buffToken TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        `;
        await connection.execute(createBuffTokenTableSQL);
        
        // 创建uutoken表（只有uuToken字段）
        const createUuTokenTableSQL = `
            CREATE TABLE IF NOT EXISTS uutoken (
                uuToken TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        `;
        await connection.execute(createUuTokenTableSQL);
        
        // 创建c5token表（只有c5Token字段）
        const createC5TokenTableSQL = `
            CREATE TABLE IF NOT EXISTS c5token (
                c5Token TEXT,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
            )
        `;
        await connection.execute(createC5TokenTableSQL);
        
        // 检查并更新bufftoken表的字段类型，以防字段长度不足
        try {
            const [buffTokenColumns] = await connection.execute("SHOW COLUMNS FROM bufftoken LIKE 'buffToken'");
            if (buffTokenColumns.length > 0 && buffTokenColumns[0].Type !== 'text') {
                await connection.execute("ALTER TABLE bufftoken MODIFY buffToken TEXT");
                console.log('已将bufftoken表的buffToken字段修改为TEXT类型');
            }
        } catch (alterError) {
            console.error('修改bufftoken表字段类型失败:', alterError);
        }

        // 检查并更新uutoken表的字段类型，以防字段长度不足
        try {
            const [uuTokenColumns] = await connection.execute("SHOW COLUMNS FROM uutoken LIKE 'uuToken'");
            if (uuTokenColumns.length > 0 && uuTokenColumns[0].Type !== 'text') {
                await connection.execute("ALTER TABLE uutoken MODIFY uuToken TEXT");
                console.log('已将uutoken表的uuToken字段修改为TEXT类型');
            }
        } catch (alterError) {
            console.error('修改uutoken表字段类型失败:', alterError);
        }
        
        // 检查并更新c5token表的字段类型，以防字段长度不足
        try {
            const [c5TokenColumns] = await connection.execute("SHOW COLUMNS FROM c5token LIKE 'c5Token'");
            if (c5TokenColumns.length > 0 && c5TokenColumns[0].Type !== 'text') {
                await connection.execute("ALTER TABLE c5token MODIFY c5Token TEXT");
                console.log('已将c5token表的c5Token字段修改为TEXT类型');
            }
        } catch (alterError) {
            console.error('修改c5token表字段类型失败:', alterError);
        }

        console.log('bufftoken和uutoken表创建成功或已存在');
        await connection.end();
    } catch (error) {
        console.error('创建token表失败:', error);
    }
}

app.post('/api/tokens', async (req, res) => {
    try {
        const { tokenType, tokenValue } = req.body;
        
        if (!tokenType || !tokenValue) {
            return res.status(400).json({ 
                success: false, 
                message: 'token类型和值不能为空' 
            });
        }
        
        if (!['buff', 'uu', 'c5'].includes(tokenType)) {
            return res.status(400).json({ 
                success: false, 
                message: 'token类型必须是buff、uu或c5' 
            });
        }
        
        const connection = await createConnection();
        
        // 根据token类型选择对应的表名和字段名
        let tableName, fieldName;
        if (tokenType === 'buff') {
            tableName = 'bufftoken';
            fieldName = 'buffToken';
        } else if (tokenType === 'uu') {
            tableName = 'uutoken';
            fieldName = 'uuToken';
        } else if (tokenType === 'c5') {
            tableName = 'c5token';
            fieldName = 'c5Token';
        }
        
        // 检查是否已存在记录（每个表只有一条记录）
        const [existingRows] = await connection.execute(`SELECT * FROM ${tableName}`);
        
        let result;
        if (existingRows.length > 0) {
            // 更新现有记录（没有id字段，直接更新所有记录）
            const updateSQL = `UPDATE ${tableName} SET ${fieldName} = ?`;
            [result] = await connection.execute(updateSQL, [tokenValue]);
        } else {
            // 插入新记录
            const insertSQL = `INSERT INTO ${tableName} (${fieldName}) VALUES (?)`;
            [result] = await connection.execute(insertSQL, [tokenValue]);
        }
        
        await connection.end();
        
        res.json({
            success: true,
            message: 'token保存成功',
            data: {
                tokenType,
                tokenValue
            }
        });
        
    } catch (error) {
        console.error('保存token失败:', error);
        res.status(500).json({
            success: false,
            message: '服务器内部错误'
        });
    }
});

app.get('/api/tokens', async (req, res) => {
    try {
        const connection = await createConnection();
        
        // 分别从三个表中获取数据（每个表只有一条记录）
        const [buffTokenRows] = await connection.execute('SELECT * FROM bufftoken');
        const [uuTokenRows] = await connection.execute('SELECT * FROM uutoken');
        const [c5TokenRows] = await connection.execute('SELECT * FROM c5token');
        
        await connection.end();
        
        res.json({
            success: true,
            data: {
                buffToken: buffTokenRows.length > 0 ? buffTokenRows[0].buffToken : '',
                uuToken: uuTokenRows.length > 0 ? uuTokenRows[0].uuToken : '',
                c5Token: c5TokenRows.length > 0 ? c5TokenRows[0].c5Token : ''
            }
        });
    } catch (error) {
        console.error('获取token列表失败:', error);
        res.status(500).json({
            success: false,
            message: '服务器内部错误'
        });
    }
});

app.get('/api/health', (req, res) => {
    res.json({
        success: true,
        message: '服务器运行正常',
        timestamp: new Date().toISOString()
    });
});

app.get('/api/sell/names', async (req, res) => {
    try {
        const connection = await createConnection();
        
        // 获取sell表中的所有字段数据
        const [rows] = await connection.execute('SELECT name, enName, buffID, uuID, c5ID FROM sell');
        
        await connection.end();
        
        res.json({
            success: true,
            data: rows
        });
    } catch (error) {
        console.error('获取sell表数据失败:', error);
        res.status(500).json({
            success: false,
            message: '服务器内部错误'
        });
    }
});

// 代理C5 API请求
app.post('/api/c5-proxy', async (req, res) => {
    try {
        const { itemId, wearMin, wearMax, pageSize } = req.body;
        
        if (!itemId) {
            return res.status(400).json({ 
                success: false, 
                message: 'itemId参数不能为空' 
            });
        }
        
        // 从数据库获取C5 Token信息（用作app-key）
        const connection = await createConnection();
        const [c5TokenRows] = await connection.execute('SELECT c5Token FROM c5token LIMIT 1');
        await connection.end();
        
        let appKey = '';
        if (c5TokenRows.length > 0 && c5TokenRows[0].c5Token) {
            appKey = c5TokenRows[0].c5Token;
        } else {
            return res.status(400).json({
                success: false,
                message: '数据库中未找到有效的C5 Token信息，请先保存C5 Token'
            });
        }
        
        // 构建目标URL
        const apiUrl = `https://openapi.c5game.com/merchant/market/v2/products/search?app-key=${appKey}`;
        
        // 直接构建请求体字符串，避免JSON.stringify处理大整数的问题
        const requestBody = `{
            "itemId": ${itemId},
            "wearMin": ${wearMin || 0},
            "wearMax": ${wearMax || 1},
            "pageSize": ${pageSize || 10}
        }`;
        
        // 设置请求头以发送POST请求到C5 API
        const response = await fetch(apiUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                'Accept': 'application/json, text/plain, */*',
                'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8'
            },
            body: requestBody
        });
        
        // 获取响应文本
        const responseText = await response.text();
        
        // 尝试解析JSON
        try {
            const data = JSON.parse(responseText);
            
            // 返回解析后的数据
            res.status(response.status).json({
                success: true,
                status: response.status,
                statusText: response.statusText,
                data: data
            });
        } catch (parseError) {
            // 如果JSON解析失败，返回原始响应
            res.status(response.status).json({
                success: false,
                status: response.status,
                statusText: response.statusText,
                message: 'API响应不是有效的JSON格式',
                rawResponse: responseText
            });
        }
    } catch (error) {
        console.error('C5 API代理请求失败:', error);
        res.status(500).json({
            success: false,
            message: '服务器内部错误',
            error: error.message
        });
    }
});

// 代理BUFF API请求
app.get('/api/buff-proxy', async (req, res) => {
    try {
        const { goods_id, min_paintwear, max_paintwear } = req.query;
        
        if (!goods_id) {
            return res.status(400).json({ 
                success: false, 
                message: 'goods_id参数不能为空' 
            });
        }
        
        // 从数据库获取Cookie信息
        const connection = await createConnection();
        const [buffTokenRows] = await connection.execute('SELECT buffToken FROM bufftoken LIMIT 1');
        await connection.end();
        
        let cookieHeader = '';
        if (buffTokenRows.length > 0 && buffTokenRows[0].buffToken) {
            cookieHeader = buffTokenRows[0].buffToken;
        } else {
            return res.status(400).json({
                success: false,
                message: '数据库中未找到有效的Cookie信息，请先保存Cookie'
            });
        }
        
        // 构建目标URL
        const baseUrl = 'https://buff.163.com/api/market/goods/sell_order';
        const params = new URLSearchParams({
            game: 'csgo',
            goods_id: goods_id,
            page_num: 1,
            sort_by: 'default',
            mode: '',
            allow_tradable_cooldown: 1,
            min_paintwear: min_paintwear || '',
            max_paintwear: max_paintwear || '',
            _: Date.now()
        });

        const apiUrl = `${baseUrl}?${params.toString()}`;
        
        // 设置请求头以模拟浏览器请求，使用从数据库获取的Cookie
        const response = await fetch(apiUrl, {
            headers: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
                'Accept': 'application/json, text/plain, */*',
                'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
                'Referer': 'https://buff.163.com/',
                'Origin': 'https://buff.163.com',
                'Cookie': cookieHeader
            }
        });
        
        // 获取响应文本
        const responseText = await response.text();
        
        // 尝试解析JSON
        try {
            const data = JSON.parse(responseText);
            
            // 返回解析后的数据
            res.status(response.status).json({
                success: true,
                status: response.status,
                statusText: response.statusText,
                data: data
            });
        } catch (parseError) {
            // 如果JSON解析失败，返回原始响应
            res.status(response.status).json({
                success: false,
                status: response.status,
                statusText: response.statusText,
                message: 'API响应不是有效的JSON格式',
                rawResponse: responseText
            });
        }
    } catch (error) {
        console.error('BUFF API代理请求失败:', error);
        res.status(500).json({
            success: false,
            message: '服务器内部错误',
            error: error.message
        });
    }
});

// 创建或更新record表
async function createRecordTable() {
    try {
        const connection = await createConnection();
        
        // 检查表是否存在
        const [tables] = await connection.execute("SHOW TABLES LIKE 'record'");
        
        if (tables.length === 0) {
            // 如果表不存在，创建新表
            const createRecordTableSQL = `
                CREATE TABLE record (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    name VARCHAR(255) NOT NULL,
                    wear TEXT NOT NULL,
                    type VARCHAR(50) NOT NULL,
                    price TEXT,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                )
            `;
            await connection.execute(createRecordTableSQL);
            console.log('record表创建成功');
        } else {
            // 如果表存在，检查是否有created_at列
            const [columns] = await connection.execute("SHOW COLUMNS FROM record LIKE 'created_at'");
            
            if (columns.length === 0) {
                // 如果没有created_at列，添加它
                try {
                    await connection.execute("ALTER TABLE record ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP");
                    console.log('已为record表添加created_at列');
                } catch (alterError) {
                    console.log('created_at列可能已存在或无法添加:', alterError.message);
                }
            }
            
            // 检查wear列的数据类型，如果不是TEXT，则修改它
            const [wearColumn] = await connection.execute("SHOW COLUMNS FROM record WHERE Field = 'wear'");
            if (wearColumn.length > 0 && wearColumn[0].Type !== 'text') {
                try {
                    await connection.execute("ALTER TABLE record MODIFY wear TEXT NOT NULL");
                    console.log('已将wear列修改为TEXT类型');
                } catch (modifyError) {
                    console.log('无法修改wear列为TEXT类型:', modifyError.message);
                }
            }
            
            // 检查type列的数据类型，如果不是VARCHAR，则修改它
            const [typeColumn] = await connection.execute("SHOW COLUMNS FROM record WHERE Field = 'type'");
            if (typeColumn.length > 0 && !typeColumn[0].Type.includes('varchar')) {
                try {
                    await connection.execute("ALTER TABLE record MODIFY type VARCHAR(50) NOT NULL");
                    console.log('已将type列修改为VARCHAR类型');
                } catch (modifyError) {
                    console.log('无法修改type列为VARCHAR类型:', modifyError.message);
                }
            }
            
            // 检查是否有price列，如果没有则添加
            const [priceColumn] = await connection.execute("SHOW COLUMNS FROM record LIKE 'price'");
            if (priceColumn.length === 0) {
                try {
                    await connection.execute("ALTER TABLE record ADD COLUMN price TEXT");
                    console.log('已为record表添加price列');
                } catch (alterError) {
                    console.log('无法添加price列:', alterError.message);
                }
            }
        }
        
        console.log('record表准备就绪');
        await connection.end();
    } catch (error) {
        console.error('创建或更新record表失败:', error);
    }
}

// 保存记录到record表
app.post('/api/records', async (req, res) => {
    try {
        const { name, wear, type, price } = req.body;
        
        if (!name || wear === undefined || !type) {
            return res.status(400).json({ 
                success: false, 
                message: '名称、磨损和类型不能为空' 
            });
        }
        
        const connection = await createConnection();
        
        // 插入新记录
        const insertSQL = 'INSERT INTO record (name, wear, type, price) VALUES (?, ?, ?, ?)';
        const [result] = await connection.execute(insertSQL, [name, wear, type, price]);
        
        await connection.end();
        
        res.json({
            success: true,
            message: '记录保存成功',
            data: {
                id: result.insertId,
                name,
                wear,
                type,
                price
            }
        });
        
    } catch (error) {
        console.error('保存记录失败:', error);
        res.status(500).json({
            success: false,
            message: '服务器内部错误'
        });
    }
});

// 获取所有记录
app.get('/api/records', async (req, res) => {
    try {
        const connection = await createConnection();
        
        // 查询所有记录，按时间倒序排列
        const [rows] = await connection.execute('SELECT name, wear, type, price, created_at FROM record ORDER BY created_at DESC');
        
        // 合并相同商品的记录
        const mergedRecords = {};
        rows.forEach(row => {
            const key = `${row.name}_${row.wear}`;
            if (!mergedRecords[key]) {
                mergedRecords[key] = {
                    name: row.name,
                    wear: row.wear,
                    type: [row.type], // 使用数组存储多个平台
                    price: [row.price ? { type: row.type, price: row.price } : null] // 存储每个平台的价格
                };
            } else {
                // 如果已存在该商品记录，添加新的平台信息
                if (!mergedRecords[key].type.includes(row.type)) {
                    mergedRecords[key].type.push(row.type);
                }
                if (row.price) {
                    mergedRecords[key].price.push({ type: row.type, price: row.price });
                }
            }
        });
        
        // 转换为数组格式
        const mergedData = Object.values(mergedRecords);
        
        await connection.end();
        
        res.json({
            success: true,
            data: mergedData
        });
    } catch (error) {
        console.error('获取记录列表失败:', error);
        res.status(500).json({
            success: false,
            message: '服务器内部错误'
        });
    }
});

// 清空所有记录
app.delete('/api/records/clear', async (req, res) => {
    try {
        const connection = await createConnection();
        
        // 删除所有记录
        await connection.execute('DELETE FROM record');
        
        await connection.end();
        
        res.json({
            success: true,
            message: '所有记录已清空'
        });
    } catch (error) {
        console.error('清空记录失败:', error);
        res.status(500).json({
            success: false,
            message: '服务器内部错误'
        });
    }
});

app.listen(PORT, async () => {
    console.log(`服务器运行在端口 ${PORT}`);
    await createTokenTables();
    await createRecordTable();  // 新增：创建record表
});