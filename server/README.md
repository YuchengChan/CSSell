# CS Sell 后端服务器

## 数据库配置

### MySQL 配置
1. 确保MySQL服务器正在运行
2. 修改 `server/.env` 文件中的数据库配置：

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=你的MySQL密码
DB_NAME=cs_sell
PORT=3000
```

3. 创建数据库（如果不存在）：
```sql
CREATE DATABASE cs_sell;
```

### SQLite 备选方案
如果不想使用MySQL，可以使用SQLite版本。创建一个 `server-sqlite` 目录并运行以下命令：

## 启动服务器

```bash
cd server
npm start
```

服务器将运行在 http://localhost:3000

## API 接口

### 保存Token
- **URL**: `POST /api/tokens`
- **参数**:
  ```json
  {
    "tokenType": "buff" 或 "uu",
    "tokenValue": "token值"
  }
  ```

### 获取Token列表
- **URL**: `GET /api/tokens`

### 健康检查
- **URL**: `GET /api/health`