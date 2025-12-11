@echo off
REM VxKex 安装诊断工具启动器
REM 检查 VxKex 是否正确安装

setlocal

echo ================================================
echo VxKex 安装诊断工具
echo ================================================
echo.

REM 获取脚本所在目录
set "SCRIPT_DIR=%~dp0"

REM 运行 PowerShell 诊断脚本
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%VxKex-Diagnostic.ps1"

if %errorlevel% neq 0 (
    echo.
    echo PowerShell 脚本执行失败
    pause
)

endlocal
