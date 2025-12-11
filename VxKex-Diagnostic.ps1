# VxKex 安装诊断工具
# 用于验证 VxKex 是否正确安装

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "VxKex 安装诊断工具" -ForegroundColor Yellow
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host ""

# 诊断结果收集
$diagnosticResults = @()
$allPassed = $true

# 1. 检查 VxKex 安装目录
Write-Host "[1/6] 检查 VxKex 安装目录..." -ForegroundColor Cyan
$vxkexInstallPaths = @(
    "$env:ProgramFiles\VxKex",
    "${env:ProgramFiles(x86)}\VxKex",
    "$env:SystemRoot\System32\VxKexLoader.dll"
)

$vxkexFound = $false
foreach ($path in $vxkexInstallPaths) {
    if (Test-Path $path) {
        Write-Host "  ✓ 找到: $path" -ForegroundColor Green
        $diagnosticResults += "✓ VxKex 安装目录存在: $path"
        $vxkexFound = $true

        # 列出目录内容
        if (Test-Path $path -PathType Container) {
            $files = Get-ChildItem $path -ErrorAction SilentlyContinue
            if ($files) {
                Write-Host "  文件列表:" -ForegroundColor Gray
                $files | ForEach-Object {
                    Write-Host "    - $($_.Name)" -ForegroundColor Gray
                }
            }
        }
    }
}

if (-not $vxkexFound) {
    Write-Host "  ✗ 未找到 VxKex 安装目录" -ForegroundColor Red
    $diagnosticResults += "✗ VxKex 可能未正确安装"
    $allPassed = $false
}
Write-Host ""

# 2. 检查 VxKex 注册表项
Write-Host "[2/6] 检查 VxKex 注册表项..." -ForegroundColor Cyan
$regPaths = @(
    "HKLM:\SOFTWARE\VXsoft\VxKex",
    "HKLM:\SOFTWARE\WOW6432Node\VXsoft\VxKex",
    "HKCU:\Software\VXsoft\VxKex"
)

$regFound = $false
foreach ($regPath in $regPaths) {
    if (Test-Path $regPath) {
        Write-Host "  ✓ 找到注册表项: $regPath" -ForegroundColor Green
        $diagnosticResults += "✓ VxKex 注册表项存在: $regPath"
        $regFound = $true

        # 读取注册表值
        try {
            $values = Get-ItemProperty $regPath -ErrorAction SilentlyContinue
            if ($values) {
                $values.PSObject.Properties | Where-Object { $_.Name -notlike "PS*" } | ForEach-Object {
                    Write-Host "    - $($_.Name) = $($_.Value)" -ForegroundColor Gray
                }
            }
        } catch {
            # 忽略错误
        }
    }
}

if (-not $regFound) {
    Write-Host "  ✗ 未找到 VxKex 注册表项" -ForegroundColor Red
    $diagnosticResults += "✗ VxKex 注册表项不存在"
    $allPassed = $false
}
Write-Host ""

# 3. 检查 Clash Verge 配置
Write-Host "[3/6] 检查 Clash Verge VxKex 配置..." -ForegroundColor Cyan
$clashRegPath = "HKCU:\Software\VXsoft\VxKex\Configured"
if (Test-Path $clashRegPath) {
    $clashValues = Get-ItemProperty $clashRegPath -ErrorAction SilentlyContinue
    $clashConfigured = $false

    $clashValues.PSObject.Properties | Where-Object {
        $_.Name -like "*Clash Verge*" -or $_.Name -like "*.exe"
    } | ForEach-Object {
        Write-Host "  ✓ Clash Verge 已配置: $($_.Name) = $($_.Value)" -ForegroundColor Green
        $diagnosticResults += "✓ Clash Verge VxKex 配置: $($_.Name)"
        $clashConfigured = $true
    }

    if (-not $clashConfigured) {
        Write-Host "  ⚠ 未找到 Clash Verge 配置" -ForegroundColor Yellow
        $diagnosticResults += "⚠ Clash Verge 可能未配置 VxKex"
    }
} else {
    Write-Host "  ✗ VxKex 配置注册表项不存在" -ForegroundColor Red
    $diagnosticResults += "✗ VxKex Configured 注册表项不存在"
    $allPassed = $false
}
Write-Host ""

# 4. 检查兼容性标志
Write-Host "[4/6] 检查 Clash Verge 兼容性标志..." -ForegroundColor Cyan
$compatPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
if (Test-Path $compatPath) {
    $compatValues = Get-ItemProperty $compatPath -ErrorAction SilentlyContinue
    $compatConfigured = $false

    $compatValues.PSObject.Properties | Where-Object {
        $_.Name -like "*Clash Verge*" -and $_.Value -like "*VXKEX*"
    } | ForEach-Object {
        Write-Host "  ✓ 兼容性标志已设置: $($_.Name)" -ForegroundColor Green
        Write-Host "    值: $($_.Value)" -ForegroundColor Gray
        $diagnosticResults += "✓ 兼容性标志: $($_.Value)"
        $compatConfigured = $true
    }

    if (-not $compatConfigured) {
        Write-Host "  ⚠ 未找到 Clash Verge 兼容性标志" -ForegroundColor Yellow
        $diagnosticResults += "⚠ Clash Verge 兼容性标志未设置"
    }
} else {
    Write-Host "  ✗ 兼容性标志注册表项不存在" -ForegroundColor Red
    $diagnosticResults += "✗ 兼容性标志注册表项不存在"
}
Write-Host ""

# 5. 检查 VxKex 服务
Write-Host "[5/6] 检查 VxKex 相关服务..." -ForegroundColor Cyan
$services = Get-Service | Where-Object { $_.Name -like "*VxKex*" -or $_.DisplayName -like "*VxKex*" }
if ($services) {
    $services | ForEach-Object {
        $statusColor = if ($_.Status -eq "Running") { "Green" } else { "Yellow" }
        Write-Host "  ✓ 服务: $($_.DisplayName) [$($_.Status)]" -ForegroundColor $statusColor
        $diagnosticResults += "服务: $($_.DisplayName) - $($_.Status)"
    }
} else {
    Write-Host "  ⓘ 未找到 VxKex 服务 (这是正常的)" -ForegroundColor Gray
    $diagnosticResults += "ⓘ VxKex 不使用 Windows 服务"
}
Write-Host ""

# 6. 检查 VxKexLoader.dll
Write-Host "[6/6] 检查 VxKexLoader.dll..." -ForegroundColor Cyan
$loaderPaths = @(
    "$env:SystemRoot\System32\VxKexLoader.dll",
    "$env:SystemRoot\SysWOW64\VxKexLoader.dll"
)

$loaderFound = $false
foreach ($loaderPath in $loaderPaths) {
    if (Test-Path $loaderPath) {
        $fileInfo = Get-Item $loaderPath
        Write-Host "  ✓ 找到: $loaderPath" -ForegroundColor Green
        Write-Host "    大小: $([math]::Round($fileInfo.Length / 1KB, 2)) KB" -ForegroundColor Gray
        Write-Host "    修改时间: $($fileInfo.LastWriteTime)" -ForegroundColor Gray
        $diagnosticResults += "✓ VxKexLoader.dll 存在: $loaderPath"
        $loaderFound = $true
    }
}

if (-not $loaderFound) {
    Write-Host "  ✗ 未找到 VxKexLoader.dll" -ForegroundColor Red
    $diagnosticResults += "✗ VxKexLoader.dll 不存在"
    $allPassed = $false
}
Write-Host ""

# 显示诊断摘要
Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host "诊断结果摘要" -ForegroundColor Yellow
Write-Host "=" * 70 -ForegroundColor Cyan

foreach ($result in $diagnosticResults) {
    if ($result -like "✓*") {
        Write-Host $result -ForegroundColor Green
    } elseif ($result -like "✗*") {
        Write-Host $result -ForegroundColor Red
    } elseif ($result -like "⚠*") {
        Write-Host $result -ForegroundColor Yellow
    } else {
        Write-Host $result -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "=" * 70 -ForegroundColor Cyan

# 最终结论
if ($allPassed -and $vxkexFound -and $regFound) {
    Write-Host "✅ 诊断结果: VxKex 已正确安装！" -ForegroundColor Green
    Write-Host ""
    Write-Host "建议:" -ForegroundColor Yellow
    Write-Host "  1. 尝试启动 Clash Verge,查看是否能正常运行" -ForegroundColor White
    Write-Host "  2. 如果仍有问题,请检查 Windows 事件查看器中的错误日志" -ForegroundColor White
} else {
    Write-Host "❌ 诊断结果: VxKex 可能未正确安装！" -ForegroundColor Red
    Write-Host ""
    Write-Host "建议修复步骤:" -ForegroundColor Yellow
    Write-Host "  1. 重新以管理员身份运行配置工具" -ForegroundColor White
    Write-Host "  2. 确保 Windows 7 已安装最新的 Service Pack" -ForegroundColor White
    Write-Host "  3. 检查杀毒软件是否阻止了安装" -ForegroundColor White
    Write-Host "  4. 手动运行 KexSetup_Release_1_1_2_1428.exe 进行安装" -ForegroundColor White
}

Write-Host "=" * 70 -ForegroundColor Cyan
Write-Host ""
Write-Host "按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
