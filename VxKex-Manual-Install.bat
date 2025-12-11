@echo off
REM VxKex 手动安装工具启动器

setlocal

echo ================================================
echo VxKex 手动安装工具
echo ================================================
echo.
echo 此工具将帮助您手动安装 VxKex
echo.

REM 检查管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 错误: 需要管理员权限运行
    echo.
    echo 请右键点击此文件,选择"以管理员身份运行"
    echo.
    pause
    exit /b 1
)

REM 获取脚本所在目录
set "SCRIPT_DIR=%~dp0"

REM 运行 PowerShell 脚本
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%VxKex-Manual-Install.ps1"

if %errorlevel% neq 0 (
    echo.
    echo PowerShell 脚本执行失败
    pause
)

endlocal
