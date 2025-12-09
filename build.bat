@echo off
REM Clash Verge VxKex Configurator 构建脚本
REM 使用 PyInstaller 打包成单个 exe 文件

echo ========================================
echo   Clash Verge VxKex Configurator
echo   开始构建...
echo ========================================
echo.

REM 检查 Python 是否安装
python --version >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 Python，请先安装 Python 3.8+
    pause
    exit /b 1
)

echo [1/3] 检查并安装依赖...
pip install -r requirements.txt
if errorlevel 1 (
    echo [错误] 依赖安装失败
    pause
    exit /b 1
)

echo.
echo [2/3] 清理旧的构建文件...
if exist build rmdir /s /q build
if exist dist rmdir /s /q dist
if exist *.spec del /q *.spec

echo.
echo [3/3] 使用 PyInstaller 打包...
pyinstaller build.spec
if errorlevel 1 (
    echo [错误] 打包失败
    pause
    exit /b 1
)

echo.
echo ========================================
echo   构建完成！
echo ========================================
echo.
echo 生成的文件位于: dist\ClashVerge-VxKex-Configurator.exe
echo 文件大小约: 8-10 MB（包含 VxKex 安装包）
echo.
echo 您可以将此 exe 文件分发给用户使用。
echo.

pause
