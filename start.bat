@echo off
echo 启动后端服务器...
start cmd /k "cd /d %~dp0server && node server.js"

timeout /t 3 /nobreak >nul

echo 启动前端服务器...
start cmd /k "cd /d %~dp0 && npm run dev"

exit