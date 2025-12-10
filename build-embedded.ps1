# 创建内嵌资源的自解压 PowerShell 脚本
# 将所有文件 Base64 编码后嵌入到一个 PS1 文件中

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Clash Verge VxKex Configurator - 内嵌式构建   " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""

# 检查必需文件
$requiredFiles = @(
    "ClashVerge-VxKex-Configurator.bat",
    "VxKexConfigurator.ps1",
    "resources\KexSetup_Release_1_1_2_1428.exe"
)

Write-Host "检查必需文件..." -ForegroundColor Yellow
foreach ($file in $requiredFiles) {
    if (-not (Test-Path $file)) {
        Write-Host "  ❌ 文件不存在: $file" -ForegroundColor Red
        exit 1
    }
    Write-Host "  ✓ $file" -ForegroundColor Green
}
Write-Host ""

# 读取文件并转换为 Base64
Write-Host "编码文件为 Base64..." -ForegroundColor Yellow

$batContent = [Convert]::ToBase64String([IO.File]::ReadAllBytes("ClashVerge-VxKex-Configurator.bat"))
Write-Host "  ✓ BAT 文件编码完成" -ForegroundColor Green

$ps1Content = [Convert]::ToBase64String([IO.File]::ReadAllBytes("VxKexConfigurator.ps1"))
Write-Host "  ✓ PS1 文件编码完成" -ForegroundColor Green

$exeContent = [Convert]::ToBase64String([IO.File]::ReadAllBytes("resources\KexSetup_Release_1_1_2_1428.exe"))
Write-Host "  ✓ VxKex 安装包编码完成" -ForegroundColor Green
Write-Host ""

# 创建自解压脚本模板
$selfExtractingScript = @"
# Clash Verge VxKex Configurator - 自解压版本
# 单文件包含所有资源，无需额外文件

`$ErrorActionPreference = "Stop"

# 检查管理员权限
`$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not `$isAdmin) {
    Write-Host "错误: 需要管理员权限运行此工具" -ForegroundColor Red
    Write-Host "请右键选择 '以管理员身份运行'" -ForegroundColor Yellow
    Read-Host "按回车键退出"
    exit 1
}

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Clash Verge VxKex 一键配置工具 (自解压版)   " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "正在解压文件..." -ForegroundColor Yellow

# 创建临时目录
`$tempDir = Join-Path `$env:TEMP "ClashVerge-VxKex-Config-`$(Get-Date -Format 'yyyyMMddHHmmss')"
New-Item -ItemType Directory -Path `$tempDir -Force | Out-Null
Write-Host "  临时目录: `$tempDir" -ForegroundColor Gray

# Base64 编码的文件内容
`$batBase64 = @"
$batContent
"@

`$ps1Base64 = @"
$ps1Content
"@

`$exeBase64 = @"
$exeContent
"@

# 解码并保存文件
Write-Host "  解压 BAT 启动器..." -ForegroundColor Gray
[IO.File]::WriteAllBytes("`$tempDir\ClashVerge-VxKex-Configurator.bat", [Convert]::FromBase64String(`$batBase64))

Write-Host "  解压 PowerShell 脚本..." -ForegroundColor Gray
[IO.File]::WriteAllBytes("`$tempDir\VxKexConfigurator.ps1", [Convert]::FromBase64String(`$ps1Base64))

Write-Host "  解压 VxKex 安装包..." -ForegroundColor Gray
New-Item -ItemType Directory -Path "`$tempDir\resources" -Force | Out-Null
[IO.File]::WriteAllBytes("`$tempDir\resources\KexSetup_Release_1_1_2_1428.exe", [Convert]::FromBase64String(`$exeBase64))

Write-Host ""
Write-Host "✓ 文件解压完成!" -ForegroundColor Green
Write-Host ""
Write-Host "正在启动配置工具..." -ForegroundColor Yellow
Write-Host ""

# 切换到临时目录并执行
Set-Location `$tempDir

try {
    # 直接运行 PowerShell 脚本（已经有管理员权限）
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File "VxKexConfigurator.ps1"
}
catch {
    Write-Host "错误: `$(`$_.Exception.Message)" -ForegroundColor Red
    Read-Host "按回车键退出"
}
finally {
    # 清理临时文件
    Write-Host ""
    Write-Host "正在清理临时文件..." -ForegroundColor Yellow
    Set-Location `$env:TEMP
    Start-Sleep -Seconds 2
    Remove-Item -Path `$tempDir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host "✓ 清理完成" -ForegroundColor Green
}
"@

# 创建输出目录
if (-not (Test-Path "dist")) {
    New-Item -ItemType Directory -Path "dist" | Out-Null
}

# 保存自解压脚本
$outputScript = "dist\ClashVerge-VxKex-Configurator-Embedded.ps1"
[IO.File]::WriteAllText($outputScript, $selfExtractingScript, [System.Text.Encoding]::UTF8)

Write-Host "创建自解压脚本..." -ForegroundColor Yellow
Write-Host "  输出: $outputScript" -ForegroundColor Cyan
$size = [math]::Round((Get-Item $outputScript).Length / 1MB, 2)
Write-Host "  大小: $size MB" -ForegroundColor Cyan
Write-Host ""

# 创建 BAT 启动器
$batLauncher = @"
@echo off
REM Clash Verge VxKex Configurator - 自解压启动器

REM 请求管理员权限
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 正在请求管理员权限...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

REM 运行自解压 PowerShell 脚本
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0ClashVerge-VxKex-Configurator-Embedded.ps1"
pause
"@

$batLauncherPath = "dist\ClashVerge-VxKex-Configurator.bat"
[IO.File]::WriteAllText($batLauncherPath, $batLauncher, [System.Text.Encoding]::Default)

Write-Host "✓ BAT 启动器创建成功!" -ForegroundColor Green
Write-Host "  输出: $batLauncherPath" -ForegroundColor Cyan
Write-Host ""

Write-Host "==================================================" -ForegroundColor Green
Write-Host "           构建完成！                            " -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
Write-Host "输出文件:" -ForegroundColor Yellow
Write-Host "  1. dist\ClashVerge-VxKex-Configurator.bat (启动器)" -ForegroundColor Cyan
Write-Host "  2. dist\ClashVerge-VxKex-Configurator-Embedded.ps1 (自解压脚本)" -ForegroundColor Cyan
Write-Host ""
Write-Host "使用方法:" -ForegroundColor Yellow
Write-Host "  方式1: 双击 ClashVerge-VxKex-Configurator.bat" -ForegroundColor Gray
Write-Host "  方式2: 右键 ClashVerge-VxKex-Configurator-Embedded.ps1 → 以管理员身份运行" -ForegroundColor Gray
Write-Host ""
Write-Host "将这两个文件一起分发给用户即可!" -ForegroundColor Green
