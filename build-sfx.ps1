# 构建 7-Zip SFX 自解压 EXE
# 将所有文件打包成一个单独的可执行文件

Write-Host "Clash Verge VxKex Configurator - SFX Build Script" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# 检查 7-Zip 是否安装
$7zipPath = "C:\Program Files\7-Zip\7z.exe"
if (-not (Test-Path $7zipPath)) {
    $7zipPath = "C:\Program Files (x86)\7-Zip\7z.exe"
    if (-not (Test-Path $7zipPath)) {
        Write-Host "❌ 错误: 未找到 7-Zip" -ForegroundColor Red
        Write-Host "请安装 7-Zip: https://www.7-zip.org/" -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "✓ 找到 7-Zip: $7zipPath" -ForegroundColor Green
Write-Host ""

# 创建临时目录
$tempDir = "temp_sfx"
if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $tempDir | Out-Null

# 复制文件到临时目录
Write-Host "复制文件..." -ForegroundColor Yellow
Copy-Item "ClashVerge-VxKex-Configurator.bat" -Destination $tempDir
Copy-Item "VxKexConfigurator.ps1" -Destination $tempDir
Copy-Item "resources" -Destination $tempDir -Recurse

# 创建 7z 压缩包
Write-Host "创建压缩包..." -ForegroundColor Yellow
$archiveName = "temp_archive.7z"
if (Test-Path $archiveName) {
    Remove-Item $archiveName -Force
}

& $7zipPath a -t7z -mx9 $archiveName "$tempDir\*" | Out-Null

if (-not (Test-Path $archiveName)) {
    Write-Host "❌ 创建压缩包失败" -ForegroundColor Red
    exit 1
}

Write-Host "✓ 压缩包创建成功" -ForegroundColor Green

# 下载 7-Zip SFX 模块 (如果不存在)
$sfxModule = "7zSD.sfx"
$sfxUrl = "https://github.com/chrislgarry/7-Zip-zstd/releases/download/v22.01-v1.5.5-R3/7z22.01-zstd-x64.exe"

if (-not (Test-Path $sfxModule)) {
    Write-Host ""
    Write-Host "下载 7-Zip SFX 模块..." -ForegroundColor Yellow
    Write-Host "注意: 你需要手动从 7-Zip 安装目录复制 7zSD.sfx" -ForegroundColor Yellow
    Write-Host "位置: C:\Program Files\7-Zip\7zSD.sfx" -ForegroundColor Gray
    Write-Host ""

    $7zipSfxPath = "C:\Program Files\7-Zip\7zSD.sfx"
    if (Test-Path $7zipSfxPath) {
        Copy-Item $7zipSfxPath -Destination $sfxModule
        Write-Host "✓ 复制 SFX 模块成功" -ForegroundColor Green
    } else {
        Write-Host "❌ 未找到 7zSD.sfx" -ForegroundColor Red
        Write-Host "请手动将 7zSD.sfx 复制到当前目录" -ForegroundColor Yellow
        exit 1
    }
}

# 创建输出目录
if (-not (Test-Path "dist")) {
    New-Item -ItemType Directory -Path "dist" | Out-Null
}

# 组合成 SFX EXE
Write-Host ""
Write-Host "创建自解压 EXE..." -ForegroundColor Yellow

$outputExe = "dist\ClashVerge-VxKex-Configurator.exe"
if (Test-Path $outputExe) {
    Remove-Item $outputExe -Force
}

# 方法1: 使用 copy /b 命令组合文件
cmd /c "copy /b $sfxModule + sfx-config.txt + $archiveName $outputExe" | Out-Null

if (Test-Path $outputExe) {
    Write-Host "✓ SFX EXE 创建成功!" -ForegroundColor Green
    Write-Host ""
    Write-Host "输出文件: $outputExe" -ForegroundColor Cyan
    $size = [math]::Round((Get-Item $outputExe).Length / 1MB, 2)
    Write-Host "文件大小: $size MB" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "使用方法:" -ForegroundColor Yellow
    Write-Host "1. 右键 ClashVerge-VxKex-Configurator.exe" -ForegroundColor Gray
    Write-Host "2. 以管理员身份运行" -ForegroundColor Gray
    Write-Host "3. 自动解压并启动配置工具" -ForegroundColor Gray
} else {
    Write-Host "❌ 创建 SFX EXE 失败" -ForegroundColor Red
}

# 清理临时文件
Write-Host ""
Write-Host "清理临时文件..." -ForegroundColor Yellow
Remove-Item -Path $tempDir -Recurse -Force
Remove-Item -Path $archiveName -Force

Write-Host "✓ 完成!" -ForegroundColor Green
