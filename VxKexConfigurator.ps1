# Clash Verge VxKex 一键配置工具
# PowerShell + Windows Forms 版本

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# 全局变量
$script:VxKexInstallerPath = "$PSScriptRoot\KexSetup_Release_1_1_2_1428.exe"
$script:ClashVergeExePath = ""

# 创建主窗体
$form = New-Object System.Windows.Forms.Form
$form.Text = "Clash Verge VxKex 一键配置工具 v5.0.0"
$form.Size = New-Object System.Drawing.Size(600, 500)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# 标题标签
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Location = New-Object System.Drawing.Point(20, 20)
$titleLabel.Size = New-Object System.Drawing.Size(560, 30)
$titleLabel.Text = "Clash Verge Rev - VxKex 兼容性配置工具"
$titleLabel.Font = New-Object System.Drawing.Font("Microsoft YaHei UI", 14, [System.Drawing.FontStyle]::Bold)
$titleLabel.TextAlign = "MiddleCenter"
$form.Controls.Add($titleLabel)

# 说明标签
$descLabel = New-Object System.Windows.Forms.Label
$descLabel.Location = New-Object System.Drawing.Point(20, 60)
$descLabel.Size = New-Object System.Drawing.Size(560, 60)
$descLabel.Text = "此工具将自动安装 VxKex 并配置 Clash Verge Rev 的兼容性设置，`n使其能在 Windows 7 系统上正常运行。`n`n⚠️ 请确保以管理员权限运行此工具！"
$descLabel.Font = New-Object System.Drawing.Font("Microsoft YaHei UI", 9)
$form.Controls.Add($descLabel)

# Clash Verge 路径选择组
$pathGroupBox = New-Object System.Windows.Forms.GroupBox
$pathGroupBox.Location = New-Object System.Drawing.Point(20, 130)
$pathGroupBox.Size = New-Object System.Drawing.Size(560, 80)
$pathGroupBox.Text = "Clash Verge 安装路径"
$form.Controls.Add($pathGroupBox)

# 路径文本框
$pathTextBox = New-Object System.Windows.Forms.TextBox
$pathTextBox.Location = New-Object System.Drawing.Point(10, 25)
$pathTextBox.Size = New-Object System.Drawing.Size(440, 25)
$pathTextBox.ReadOnly = $true
$pathGroupBox.Controls.Add($pathTextBox)

# 浏览按钮
$browseButton = New-Object System.Windows.Forms.Button
$browseButton.Location = New-Object System.Drawing.Point(460, 23)
$browseButton.Size = New-Object System.Drawing.Size(85, 28)
$browseButton.Text = "浏览..."
$browseButton.Add_Click({
    $fileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $fileDialog.Filter = "可执行文件 (*.exe)|*.exe"
    $fileDialog.Title = "选择 Clash Verge Rev 可执行文件"
    $fileDialog.FileName = "Clash Verge.exe"

    if ($fileDialog.ShowDialog() -eq "OK") {
        $pathTextBox.Text = $fileDialog.FileName
        $script:ClashVergeExePath = $fileDialog.FileName
        $statusLabel.Text = "✓ 已选择: $($fileDialog.FileName)"
        $statusLabel.ForeColor = [System.Drawing.Color]::Green
    }
})
$pathGroupBox.Controls.Add($browseButton)

# 提示标签
$pathHintLabel = New-Object System.Windows.Forms.Label
$pathHintLabel.Location = New-Object System.Drawing.Point(10, 55)
$pathHintLabel.Size = New-Object System.Drawing.Size(540, 20)
$pathHintLabel.Text = "💡 通常位于: C:\Program Files\Clash Verge\Clash Verge.exe"
$pathHintLabel.Font = New-Object System.Drawing.Font("Microsoft YaHei UI", 8)
$pathHintLabel.ForeColor = [System.Drawing.Color]::Gray
$pathGroupBox.Controls.Add($pathHintLabel)

# 状态标签
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(20, 220)
$statusLabel.Size = New-Object System.Drawing.Size(560, 25)
$statusLabel.Text = "请选择 Clash Verge 可执行文件路径"
$statusLabel.Font = New-Object System.Drawing.Font("Microsoft YaHei UI", 9)
$statusLabel.ForeColor = [System.Drawing.Color]::Blue
$form.Controls.Add($statusLabel)

# 进度文本框
$progressTextBox = New-Object System.Windows.Forms.TextBox
$progressTextBox.Location = New-Object System.Drawing.Point(20, 255)
$progressTextBox.Size = New-Object System.Drawing.Size(560, 120)
$progressTextBox.Multiline = $true
$progressTextBox.ScrollBars = "Vertical"
$progressTextBox.ReadOnly = $true
$progressTextBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$form.Controls.Add($progressTextBox)

# 一键配置按钮
$configButton = New-Object System.Windows.Forms.Button
$configButton.Location = New-Object System.Drawing.Point(180, 390)
$configButton.Size = New-Object System.Drawing.Size(240, 45)
$configButton.Text = "🚀 一键启用 VxKex"
$configButton.Font = New-Object System.Drawing.Font("Microsoft YaHei UI", 12, [System.Drawing.FontStyle]::Bold)
$configButton.BackColor = [System.Drawing.Color]::FromArgb(76, 175, 80)
$configButton.ForeColor = [System.Drawing.Color]::White
$configButton.FlatStyle = "Flat"
$configButton.Add_Click({
    Start-Configuration
})
$form.Controls.Add($configButton)

# 添加日志函数
function Add-Log {
    param([string]$message)
    $timestamp = Get-Date -Format "HH:mm:ss"
    $progressTextBox.AppendText("[$timestamp] $message`r`n")
    $progressTextBox.ScrollToCaret()
    [System.Windows.Forms.Application]::DoEvents()
}

# 检查管理员权限
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# 检查系统前置条件
function Test-SystemRequirements {
    Add-Log "检查系统前置条件..."

    $issues = @()

    # 1. 检查 Windows 版本
    $osInfo = Get-WmiObject -Class Win32_OperatingSystem
    $osVersion = [System.Environment]::OSVersion.Version

    if ($osVersion.Major -lt 6 -or ($osVersion.Major -eq 6 -and $osVersion.Minor -lt 1)) {
        $issues += "⚠ Windows 版本过低 (需要 Windows 7 SP1 或更高版本)"
        Add-Log "  ✗ Windows 版本: $($osInfo.Caption) - 不支持" -ForegroundColor Red
    } else {
        Add-Log "  ✓ Windows 版本: $($osInfo.Caption)" -ForegroundColor Green
    }

    # 2. 检查 Service Pack
    if ($osInfo.ServicePackMajorVersion -lt 1 -and $osVersion.Major -eq 6 -and $osVersion.Minor -eq 1) {
        $issues += "⚠ 需要安装 Windows 7 Service Pack 1"
        Add-Log "  ✗ 未检测到 Service Pack 1" -ForegroundColor Red
    } else {
        Add-Log "  ✓ Service Pack: $($osInfo.ServicePackMajorVersion).$($osInfo.ServicePackMinorVersion)" -ForegroundColor Green
    }

    # 3. 检查必需的系统更新 (KB2533623 和 KB2670838)
    Add-Log "  检查推荐的系统更新..."
    $kb2533623 = Get-HotFix -Id KB2533623 -ErrorAction SilentlyContinue
    $kb2670838 = Get-HotFix -Id KB2670838 -ErrorAction SilentlyContinue

    if (-not $kb2533623) {
        $issues += "⚠ 推荐安装 KB2533623 (微软 API 更新)"
        Add-Log "    ⚠ KB2533623 未安装 (推荐安装)" -ForegroundColor Yellow
    } else {
        Add-Log "    ✓ KB2533623 已安装" -ForegroundColor Green
    }

    if (-not $kb2670838) {
        $issues += "⚠ 推荐安装 KB2670838 (平台更新)"
        Add-Log "    ⚠ KB2670838 未安装 (推荐安装)" -ForegroundColor Yellow
    } else {
        Add-Log "    ✓ KB2670838 已安装" -ForegroundColor Green
    }

    # 4. 检查磁盘空间
    $systemDrive = $env:SystemDrive
    $drive = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='$systemDrive'"
    $freeSpaceMB = [math]::Round($drive.FreeSpace / 1MB, 2)

    if ($freeSpaceMB -lt 50) {
        $issues += "⚠ 磁盘空间不足 ($freeSpaceMB MB)"
        Add-Log "  ✗ 可用空间: $freeSpaceMB MB (需要至少 50 MB)" -ForegroundColor Red
    } else {
        Add-Log "  ✓ 可用磁盘空间: $freeSpaceMB MB" -ForegroundColor Green
    }

    return $issues
}

# 验证 VxKex 安装
function Test-VxKexInstallation {
    Add-Log "验证 VxKex 安装..."

    $checksPassed = 0
    $checksTotal = 5

    # 1. 检查安装目录
    $installPaths = @(
        "$env:ProgramFiles\VxKex",
        "${env:ProgramFiles(x86)}\VxKex"
    )

    $installFound = $false
    foreach ($path in $installPaths) {
        if (Test-Path $path) {
            Add-Log "  ✓ [1/$checksTotal] VxKex 安装目录: $path"
            $installFound = $true
            $checksPassed++
            break
        }
    }

    if (-not $installFound) {
        Add-Log "  ✗ [1/$checksTotal] VxKex 安装目录不存在"
        return @{
            Success = $false
            Message = "VxKex 安装目录不存在"
            ChecksPassed = $checksPassed
            ChecksTotal = $checksTotal
        }
    }

    # 2. 检查 VxKexLoader.dll
    $loaderPaths = @(
        "$env:SystemRoot\System32\VxKexLoader.dll",
        "$env:SystemRoot\SysWOW64\VxKexLoader.dll"
    )

    $loaderFound = $false
    foreach ($path in $loaderPaths) {
        if (Test-Path $path) {
            Add-Log "  ✓ [2/$checksTotal] VxKexLoader.dll: $path"
            $loaderFound = $true
            $checksPassed++
            break
        }
    }

    if (-not $loaderFound) {
        Add-Log "  ✗ [2/$checksTotal] VxKexLoader.dll 不存在"
    }

    # 3. 检查注册表 - HKLM
    $regPathsHKLM = @(
        "HKLM:\SOFTWARE\VXsoft\VxKex",
        "HKLM:\SOFTWARE\WOW6432Node\VXsoft\VxKex"
    )

    $regFoundHKLM = $false
    foreach ($regPath in $regPathsHKLM) {
        if (Test-Path $regPath) {
            Add-Log "  ✓ [3/$checksTotal] VxKex 注册表 (HKLM): $regPath"
            $regFoundHKLM = $true
            $checksPassed++
            break
        }
    }

    if (-not $regFoundHKLM) {
        Add-Log "  ✗ [3/$checksTotal] VxKex 注册表 (HKLM) 不存在"
    }

    # 4. 检查用户配置注册表
    $configRegPath = "HKCU:\Software\VXsoft\VxKex"
    if (Test-Path $configRegPath) {
        Add-Log "  ✓ [4/$checksTotal] VxKex 配置注册表 (HKCU): $configRegPath"
        $checksPassed++
    } else {
        Add-Log "  ⚠ [4/$checksTotal] VxKex 配置注册表不存在 (将自动创建)"
        # 尝试创建
        try {
            New-Item -Path $configRegPath -Force | Out-Null
            Add-Log "    ✓ 已创建配置注册表"
            $checksPassed++
        } catch {
            Add-Log "    ✗ 创建配置注册表失败: $($_.Exception.Message)"
        }
    }

    # 5. 检查 Shell Extension
    $shellExtPath = "HKLM:\SOFTWARE\Classes\*\ShellEx\PropertySheetHandlers\VxKex"
    if (Test-Path $shellExtPath) {
        Add-Log "  ✓ [5/$checksTotal] VxKex Shell Extension 已注册"
        $checksPassed++
    } else {
        Add-Log "  ⚠ [5/$checksTotal] VxKex Shell Extension 未注册 (可选)"
    }

    # 返回验证结果
    $success = $checksPassed -ge 3  # 至少通过 3 项核心检查

    return @{
        Success = $success
        Message = if ($success) { "VxKex 验证通过 ($checksPassed/$checksTotal)" } else { "VxKex 安装不完整 ($checksPassed/$checksTotal)" }
        ChecksPassed = $checksPassed
        ChecksTotal = $checksTotal
    }
}

# 安装 VxKex (增强版)
function Install-VxKex {
    Add-Log "开始安装 VxKex..."

    if (-not (Test-Path $script:VxKexInstallerPath)) {
        Add-Log "❌ 错误: 找不到 VxKex 安装包"
        Add-Log "路径: $script:VxKexInstallerPath"
        return $false
    }

    try {
        Add-Log "运行 VxKex 安装程序 (静默模式)..."
        $process = Start-Process -FilePath $script:VxKexInstallerPath -ArgumentList "/VERYSILENT", "/NORESTART" -Wait -PassThru

        if ($process.ExitCode -eq 0) {
            Add-Log "✓ VxKex 安装程序执行完毕 (退出代码: 0)"

            # 等待文件系统刷新
            Start-Sleep -Seconds 3

            # 验证安装
            $validation = Test-VxKexInstallation

            if ($validation.Success) {
                Add-Log "✅ VxKex 安装成功并通过验证!"
                Add-Log "   验证结果: $($validation.ChecksPassed)/$($validation.ChecksTotal) 项通过"
                return $true
            } else {
                Add-Log "⚠ VxKex 安装程序执行成功,但验证失败"
                Add-Log "   验证结果: $($validation.ChecksPassed)/$($validation.ChecksTotal) 项通过"
                Add-Log "   详细信息: $($validation.Message)"
                return $false
            }
        } else {
            Add-Log "❌ VxKex 安装失败 (退出代码: $($process.ExitCode))"
            return $false
        }
    } catch {
        Add-Log "❌ 安装 VxKex 时出错: $($_.Exception.Message)"
        return $false
    }
}

# 验证 Clash Verge 配置
function Test-ClashVergeConfiguration {
    param([string]$exePath)

    $exeName = Split-Path $exePath -Leaf
    $checksPassed = 0
    $checksTotal = 2

    # 1. 检查 VxKex 配置
    $configRegPath = "HKCU:\Software\VXsoft\VxKex\Configured"
    try {
        $configValue = Get-ItemProperty -Path $configRegPath -Name $exeName -ErrorAction Stop
        if ($configValue.$exeName -eq 1) {
            Add-Log "  ✓ [1/$checksTotal] VxKex 配置已设置: $exeName = 1"
            $checksPassed++
        } else {
            Add-Log "  ✗ [1/$checksTotal] VxKex 配置值不正确: $exeName = $($configValue.$exeName)"
        }
    } catch {
        Add-Log "  ✗ [1/$checksTotal] VxKex 配置未找到: $exeName"
    }

    # 2. 检查兼容性标志
    $compatPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
    try {
        $compatValue = Get-ItemProperty -Path $compatPath -Name $exePath -ErrorAction Stop
        if ($compatValue.$exePath -like "*VXKEX*") {
            Add-Log "  ✓ [2/$checksTotal] 兼容性标志已设置: $($compatValue.$exePath)"
            $checksPassed++
        } else {
            Add-Log "  ✗ [2/$checksTotal] 兼容性标志不正确: $($compatValue.$exePath)"
        }
    } catch {
        Add-Log "  ✗ [2/$checksTotal] 兼容性标志未找到"
    }

    return @{
        Success = ($checksPassed -eq $checksTotal)
        ChecksPassed = $checksPassed
        ChecksTotal = $checksTotal
    }
}

# 配置 Clash Verge 兼容性 (增强版)
function Set-ClashVergeCompatibility {
    param([string]$exePath)

    Add-Log "配置 Clash Verge 兼容性设置..."

    if (-not (Test-Path $exePath)) {
        Add-Log "❌ 错误: 找不到 Clash Verge 可执行文件"
        Add-Log "   路径: $exePath"
        return $false
    }

    try {
        $exeName = Split-Path $exePath -Leaf
        $exeFullPath = (Resolve-Path $exePath).Path

        Add-Log "  目标程序: $exeName"
        Add-Log "  完整路径: $exeFullPath"

        # 1. 设置 VxKex 配置 (使用文件名)
        $configRegPath = "HKCU:\Software\VXsoft\VxKex\Configured"

        if (-not (Test-Path $configRegPath)) {
            Add-Log "  创建注册表路径: $configRegPath"
            New-Item -Path $configRegPath -Force | Out-Null
        }

        Add-Log "  设置 VxKex 配置: $exeName = 1"
        Set-ItemProperty -Path $configRegPath -Name $exeName -Value 1 -Type DWord -Force

        # 验证写入
        $testValue = Get-ItemProperty -Path $configRegPath -Name $exeName -ErrorAction Stop
        if ($testValue.$exeName -ne 1) {
            throw "VxKex 配置写入失败"
        }
        Add-Log "    ✓ VxKex 配置写入成功"

        # 2. 设置兼容性标志 (使用完整路径)
        $compatPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"

        if (-not (Test-Path $compatPath)) {
            Add-Log "  创建兼容性设置路径: $compatPath"
            New-Item -Path $compatPath -Force | Out-Null
        }

        # 使用完整路径设置兼容性标志
        Add-Log "  应用兼容性标志: ~ WIN7RTM VXKEX"
        Set-ItemProperty -Path $compatPath -Name $exeFullPath -Value "~ WIN7RTM VXKEX" -Type String -Force

        # 验证写入
        $testCompat = Get-ItemProperty -Path $compatPath -Name $exeFullPath -ErrorAction Stop
        if ($testCompat.$exeFullPath -notlike "*VXKEX*") {
            throw "兼容性标志写入失败"
        }
        Add-Log "    ✓ 兼容性标志写入成功"

        # 3. 验证整体配置
        Add-Log "  验证配置..."
        $validation = Test-ClashVergeConfiguration -exePath $exeFullPath

        if ($validation.Success) {
            Add-Log "✅ Clash Verge 配置成功! ($($validation.ChecksPassed)/$($validation.ChecksTotal) 项通过)"
            return $true
        } else {
            Add-Log "⚠ Clash Verge 配置部分成功 ($($validation.ChecksPassed)/$($validation.ChecksTotal) 项通过)"
            return $false
        }
    } catch {
        Add-Log "❌ 配置兼容性时出错: $($_.Exception.Message)"
        Add-Log "   详细信息: $($_.Exception.StackTrace)"
        return $false
    }
}

# 生成诊断报告
function Export-DiagnosticReport {
    param([string]$errorMessage)

    $reportPath = "$env:TEMP\VxKex_Diagnostic_Report_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

    $report = @"
========================================
VxKex 配置工具诊断报告
========================================
生成时间: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
错误信息: $errorMessage

系统信息:
----------
操作系统: $((Get-WmiObject Win32_OperatingSystem).Caption)
版本: $([System.Environment]::OSVersion.Version)
架构: $(if ([System.Environment]::Is64BitOperatingSystem) { 'x64' } else { 'x86' })

VxKex 检查:
----------
"@

    # 检查安装目录
    $vxkexPaths = @("$env:ProgramFiles\VxKex", "${env:ProgramFiles(x86)}\VxKex")
    foreach ($path in $vxkexPaths) {
        $report += "`n[检查] $path"
        $report += if (Test-Path $path) { " - 存在" } else { " - 不存在" }
    }

    # 检查 DLL
    $dllPaths = @("$env:SystemRoot\System32\VxKexLoader.dll", "$env:SystemRoot\SysWOW64\VxKexLoader.dll")
    foreach ($path in $dllPaths) {
        $report += "`n[检查] $path"
        $report += if (Test-Path $path) { " - 存在" } else { " - 不存在" }
    }

    # 检查注册表
    $regPaths = @("HKLM:\SOFTWARE\VXsoft\VxKex", "HKCU:\Software\VXsoft\VxKex")
    foreach ($path in $regPaths) {
        $report += "`n[检查] $path"
        $report += if (Test-Path $path) { " - 存在" } else { " - 不存在" }
    }

    $report += "`n`n完整日志:`n----------`n"
    $report += $progressTextBox.Text

    $report += "`n`n========================================`n"

    $report | Out-File -FilePath $reportPath -Encoding UTF8

    return $reportPath
}

# 主配置流程 (增强版)
function Start-Configuration {
    # 禁用按钮
    $configButton.Enabled = $false
    $browseButton.Enabled = $false
    $progressTextBox.Clear()

    try {
        Add-Log "╔═══════════════════════════════════════════════════════════╗"
        Add-Log "║         Clash Verge VxKex 配置工具 v5.0.0               ║"
        Add-Log "╚═══════════════════════════════════════════════════════════╝"
        Add-Log ""

        # 步骤 1: 检查管理员权限
        Add-Log "[步骤 1/5] 验证管理员权限..."
        if (-not (Test-Administrator)) {
            Add-Log "❌ 错误: 需要管理员权限"
            [System.Windows.Forms.MessageBox]::Show(
                "请以管理员身份运行此工具！`n`n右键点击程序 → 以管理员身份运行",
                "需要管理员权限",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Warning
            )
            return
        }
        Add-Log "✓ 管理员权限验证通过"
        Add-Log ""

        # 步骤 2: 检查 Clash Verge 路径
        Add-Log "[步骤 2/5] 验证 Clash Verge 路径..."
        if ([string]::IsNullOrWhiteSpace($script:ClashVergeExePath)) {
            Add-Log "❌ 错误: 请先选择 Clash Verge 可执行文件"
            [System.Windows.Forms.MessageBox]::Show(
                "请先点击'浏览...'按钮选择 Clash Verge 可执行文件！",
                "未选择文件",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Warning
            )
            return
        }
        Add-Log "✓ Clash Verge 路径: $script:ClashVergeExePath"
        Add-Log ""

        # 步骤 3: 检查系统前置条件
        Add-Log "[步骤 3/5] 检查系统前置条件..."
        $statusLabel.Text = "⏳ 正在检查系统要求..."
        $statusLabel.ForeColor = [System.Drawing.Color]::Blue

        $sysIssues = Test-SystemRequirements

        if ($sysIssues.Count -gt 0) {
            Add-Log ""
            Add-Log "⚠ 发现 $($sysIssues.Count) 个系统警告:"
            foreach ($issue in $sysIssues) {
                Add-Log "  • $issue"
            }
            Add-Log ""

            # 如果缺少推荐更新,询问是否继续
            if ($sysIssues -match "KB\d+") {
                $result = [System.Windows.Forms.MessageBox]::Show(
                    "检测到缺少推荐的系统更新 (KB2533623 或 KB2670838)。`n`n这些更新对于 VxKex 正常运行很重要。`n`n是否继续安装?",
                    "缺少推荐更新",
                    [System.Windows.Forms.MessageBoxButtons]::YesNo,
                    [System.Windows.Forms.MessageBoxIcon]::Warning
                )

                if ($result -eq [System.Windows.Forms.DialogResult]::No) {
                    Add-Log "用户取消操作"
                    return
                }
            }
        }
        Add-Log "✓ 系统前置条件检查完成"
        Add-Log ""

        # 步骤 4: 安装 VxKex
        Add-Log "[步骤 4/5] 安装 VxKex..."
        $statusLabel.Text = "⏳ 正在安装 VxKex (可能需要 1-2 分钟)..."

        if (-not (Install-VxKex)) {
            throw "VxKex 安装失败或验证未通过"
        }
        Add-Log ""

        # 步骤 5: 配置 Clash Verge
        Add-Log "[步骤 5/5] 配置 Clash Verge 兼容性..."
        $statusLabel.Text = "⏳ 正在配置 Clash Verge..."

        if (-not (Set-ClashVergeCompatibility -exePath $script:ClashVergeExePath)) {
            throw "Clash Verge 配置失败"
        }
        Add-Log ""

        # 成功完成
        Add-Log "╔═══════════════════════════════════════════════════════════╗"
        Add-Log "║                    ✅ 配置成功完成！                      ║"
        Add-Log "╚═══════════════════════════════════════════════════════════╝"
        Add-Log ""
        Add-Log "下一步操作:"
        Add-Log "  1. 启动 Clash Verge"
        Add-Log "  2. 如果仍然无法启动,请运行 VxKex-Diagnostic.bat 进行诊断"
        Add-Log "  3. 查看 TROUBLESHOOTING.md 获取更多帮助"
        Add-Log ""

        $statusLabel.Text = "✅ 配置成功！现在可以启动 Clash Verge 了"
        $statusLabel.ForeColor = [System.Drawing.Color]::Green

        [System.Windows.Forms.MessageBox]::Show(
            "✅ 配置成功！`n`nClash Verge 现在应该可以在 Windows 7 上正常运行了。`n`n下一步:`n1. 启动 Clash Verge 测试`n2. 如有问题,运行 VxKex-Diagnostic.bat 诊断",
            "配置完成",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )

    } catch {
        Add-Log ""
        Add-Log "╔═══════════════════════════════════════════════════════════╗"
        Add-Log "║                    ❌ 配置失败！                         ║"
        Add-Log "╚═══════════════════════════════════════════════════════════╝"
        Add-Log ""
        Add-Log "错误信息: $($_.Exception.Message)"
        Add-Log ""
        Add-Log "故障排除建议:"
        Add-Log "  1. 运行 VxKex-Diagnostic.bat 进行详细诊断"
        Add-Log "  2. 查看 TROUBLESHOOTING.md 文档"
        Add-Log "  3. 尝试手动安装: VxKex-Manual-Install.bat"
        Add-Log ""

        $statusLabel.Text = "❌ 配置失败，请查看详细日志"
        $statusLabel.ForeColor = [System.Drawing.Color]::Red

        # 生成诊断报告
        $reportPath = Export-DiagnosticReport -errorMessage $_.Exception.Message
        Add-Log "诊断报告已保存: $reportPath"
        Add-Log ""

        $result = [System.Windows.Forms.MessageBox]::Show(
            "配置失败！`n`n错误: $($_.Exception.Message)`n`n诊断报告已保存至:`n$reportPath`n`n是否打开诊断报告?",
            "配置失败",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )

        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            Start-Process "notepad.exe" -ArgumentList $reportPath
        }
    } finally {
        # 重新启用按钮
        $configButton.Enabled = $true
        $browseButton.Enabled = $true
    }
}

# 尝试自动检测 Clash Verge 路径
function Find-ClashVerge {
    $possiblePaths = @(
        "$env:ProgramFiles\Clash Verge\Clash Verge.exe",
        "$env:ProgramFiles(x86)\Clash Verge\Clash Verge.exe",
        "$env:LOCALAPPDATA\Programs\Clash Verge\Clash Verge.exe"
    )

    foreach ($path in $possiblePaths) {
        if (Test-Path $path) {
            return $path
        }
    }

    return $null
}

# 初始化 - 尝试自动检测路径
$autoPath = Find-ClashVerge
if ($autoPath) {
    $pathTextBox.Text = $autoPath
    $script:ClashVergeExePath = $autoPath
    $statusLabel.Text = "✓ 已自动检测到 Clash Verge 路径"
    $statusLabel.ForeColor = [System.Drawing.Color]::Green
    Add-Log "已自动检测到 Clash Verge: $autoPath"
}

# 显示窗体
[void]$form.ShowDialog()
