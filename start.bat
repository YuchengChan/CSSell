@echo off
setlocal EnableDelayedExpansion

set "ROOT=%~dp0"
set "SERVER_DIR=%ROOT%server"
set "FRONTEND_PORT=8080"
set "BACKEND_PORT=3000"

echo ============================================
echo   CS-Sell Auto Launcher
echo   Frontend: http://127.0.0.1:%FRONTEND_PORT%
echo   Backend:  http://127.0.0.1:%BACKEND_PORT%
echo ============================================
echo.

where node >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Node.js not found.
    echo Please install Node.js from https://nodejs.org/
    goto END
)

where npm >nul 2>&1
if errorlevel 1 (
    echo [ERROR] npm not found.
    echo Please check your Node.js installation.
    goto END
)

echo [OK] Node.js detected.
echo.

if not exist "%SERVER_DIR%\node_modules" (
    echo [INFO] Installing backend dependencies...
    pushd "%SERVER_DIR%"
    call npm install
    if errorlevel 1 (
        echo [ERROR] Backend npm install failed.
        popd
        goto END
    )
    popd
    echo [OK] Backend dependencies installed.
) else (
    echo [OK] Backend dependencies ready.
)

if not exist "%ROOT%node_modules" (
    echo [INFO] Installing frontend dependencies...
    pushd "%ROOT%"
    call npm install
    if errorlevel 1 (
        echo [ERROR] Frontend npm install failed.
        popd
        goto END
    )
    popd
    echo [OK] Frontend dependencies installed.
) else (
    echo [OK] Frontend dependencies ready.
)

echo.
echo Starting backend server...
start "CS-Sell Backend" cmd /k "cd /d %SERVER_DIR% && npm run dev"

echo Waiting for backend to start...
timeout /t 3 /nobreak >nul

echo Starting frontend dev server...
start "CS-Sell Frontend" cmd /k "cd /d %ROOT% && npm run dev -- --port %FRONTEND_PORT% --host"

echo Waiting for frontend to be ready...
timeout /t 5 /nobreak >nul

echo Opening browser...
start "" "http://127.0.0.1:%FRONTEND_PORT%/"

echo.
echo ============================================
echo [DONE] All services started.
echo Frontend: http://127.0.0.1:%FRONTEND_PORT%/
echo Backend:  http://127.0.0.1:%BACKEND_PORT%/
echo ============================================
echo.
echo Press any key to close this window.
echo (Services will keep running in their own windows.)

:END
pause >nul