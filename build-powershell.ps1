# PowerShell 构建脚本
# 使用 ps2exe 将 PowerShell 脚本打包为 .exe

Write-Host "Clash Verge VxKex Configurator - PowerShell Build Script" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

# 检查 ps2exe 是否安装
Write-Host "检查 ps2exe 模块..." -ForegroundColor Yellow
if (-not (Get-Module -ListAvailable -Name ps2exe)) {
    Write-Host "ps2exe 未安装，正在安装..." -ForegroundColor Yellow
    Install-Module -Name ps2exe -Scope CurrentUser -Force
    Write-Host "✓ ps2exe 安装完成" -ForegroundColor Green
} else {
    Write-Host "✓ ps2exe 已安装" -ForegroundColor Green
}

Import-Module ps2exe

# 设置路径
$scriptPath = "$PSScriptRoot\VxKexConfigurator.ps1"
$outputPath = "$PSScriptRoot\dist\ClashVerge-VxKex-Configurator.exe"
$resourcesPath = "$PSScriptRoot\resources"

# 创建输出目录
if (-not (Test-Path "$PSScriptRoot\dist")) {
    New-Item -ItemType Directory -Path "$PSScriptRoot\dist" | Out-Null
}

Write-Host ""
Write-Host "开始打包..." -ForegroundColor Yellow
Write-Host "输入: $scriptPath" -ForegroundColor Gray
Write-Host "输出: $outputPath" -ForegroundColor Gray
Write-Host ""

# 使用 ps2exe 打包
try {
    Invoke-PS2EXE `
        -inputFile $scriptPath `
        -outputFile $outputPath `
        -noConsole `
        -title "Clash Verge VxKex Configurator" `
        -description "Clash Verge VxKex 一键配置工具" `
        -company "Clash Verge Community" `
        -product "VxKex Configurator" `
        -version "1.0.0" `
        -requireAdmin `
        -noError `
        -noOutput `
        -x64 `
        -verbose

    Write-Host ""
    Write-Host "✓ 打包成功！" -ForegroundColor Green
    Write-Host ""
    Write-Host "输出文件: $outputPath" -ForegroundColor Cyan
    Write-Host "文件大小: $([math]::Round((Get-Item $outputPath).Length / 1MB, 2)) MB" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "⚠️  注意: 请确保将 'resources' 文件夹与 .exe 放在同一目录!" -ForegroundColor Yellow

} catch {
    Write-Host ""
    Write-Host "❌ 打包失败: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
