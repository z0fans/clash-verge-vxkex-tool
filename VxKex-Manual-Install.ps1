# VxKex 手动安装工具
# 使用图形界面安装 VxKex,让用户可以看到安装过程

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "VxKex 手动安装工具" -ForegroundColor Yellow
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host ""

# 检查管理员权限
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Administrator)) {
    Write-Host "❌ 错误: 需要管理员权限" -ForegroundColor Red
    Write-Host ""
    Write-Host "请右键点击此脚本,选择'以管理员身份运行'" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "按任意键退出..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

# 查找 KexSetup 安装包
$possiblePaths = @(
    "$PSScriptRoot\KexSetup_Release_1_1_2_1428.exe",
    "$PSScriptRoot\resources\KexSetup_Release_1_1_2_1428.exe",
    "$PSScriptRoot\..\KexSetup_Release_1_1_2_1428.exe"
)

$kexSetupPath = $null
foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $kexSetupPath = $path
        break
    }
}

if (-not $kexSetupPath) {
    Write-Host "❌ 错误: 找不到 KexSetup 安装包" -ForegroundColor Red
    Write-Host ""
    Write-Host "请确保以下文件存在:" -ForegroundColor Yellow
    foreach ($path in $possiblePaths) {
        Write-Host "  - $path" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "按任意键退出..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit 1
}

Write-Host "✓ 找到 VxKex 安装包: $kexSetupPath" -ForegroundColor Green
Write-Host ""

# 提示用户选择安装模式
Write-Host "请选择安装模式:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1. 图形界面安装 (推荐,可以看到安装过程)" -ForegroundColor White
Write-Host "  2. 静默安装 (与配置工具相同)" -ForegroundColor White
Write-Host "  3. 取消安装" -ForegroundColor White
Write-Host ""
Write-Host -NoNewline "请输入选项 (1/2/3): " -ForegroundColor Cyan

$choice = Read-Host

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "启动图形界面安装..." -ForegroundColor Green
        Write-Host ""
        Write-Host "安装窗口将会打开,请按照提示完成安装。" -ForegroundColor Yellow
        Write-Host "安装完成后,请关闭此窗口。" -ForegroundColor Yellow
        Write-Host ""

        # 图形界面安装
        try {
            $process = Start-Process -FilePath $kexSetupPath -Wait -PassThru

            if ($process.ExitCode -eq 0) {
                Write-Host ""
                Write-Host "✅ VxKex 安装成功！" -ForegroundColor Green
                Write-Host ""
                Write-Host "下一步: 运行 VxKexConfigurator.ps1 配置 Clash Verge" -ForegroundColor Yellow
            } else {
                Write-Host ""
                Write-Host "⚠ VxKex 安装程序退出 (代码: $($process.ExitCode))" -ForegroundColor Yellow
                Write-Host "如果您已取消安装,请重新运行此工具。" -ForegroundColor Yellow
            }
        } catch {
            Write-Host ""
            Write-Host "❌ 安装失败: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    "2" {
        Write-Host ""
        Write-Host "启动静默安装..." -ForegroundColor Green
        Write-Host ""
        Write-Host "正在安装,请稍候..." -ForegroundColor Yellow
        Write-Host ""

        # 静默安装
        try {
            $process = Start-Process -FilePath $kexSetupPath -ArgumentList "/VERYSILENT", "/NORESTART" -Wait -PassThru

            if ($process.ExitCode -eq 0) {
                Write-Host ""
                Write-Host "✅ VxKex 安装成功！" -ForegroundColor Green
                Write-Host ""
                Write-Host "下一步: 运行 VxKexConfigurator.ps1 配置 Clash Verge" -ForegroundColor Yellow
            } else {
                Write-Host ""
                Write-Host "❌ VxKex 安装失败 (退出代码: $($process.ExitCode))" -ForegroundColor Red
                Write-Host ""
                Write-Host "建议尝试图形界面安装 (选项 1)" -ForegroundColor Yellow
            }
        } catch {
            Write-Host ""
            Write-Host "❌ 安装失败: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    "3" {
        Write-Host ""
        Write-Host "已取消安装。" -ForegroundColor Yellow
    }

    default {
        Write-Host ""
        Write-Host "无效的选项。" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
