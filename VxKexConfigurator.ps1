# Clash Verge VxKex 一键配置工具
# PowerShell + Windows Forms 版本

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# 全局变量
$script:VxKexInstallerPath = "$PSScriptRoot\KexSetup_Release_1_1_2_1428.exe"
$script:ClashVergeExePath = ""

# 创建主窗体
$form = New-Object System.Windows.Forms.Form
$form.Text = "Clash Verge VxKex 一键配置工具"
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

# 安装 VxKex
function Install-VxKex {
    Add-Log "开始安装 VxKex..."

    if (-not (Test-Path $script:VxKexInstallerPath)) {
        Add-Log "❌ 错误: 找不到 VxKex 安装包"
        Add-Log "路径: $script:VxKexInstallerPath"
        return $false
    }

    try {
        Add-Log "运行 VxKex 安装程序..."
        $process = Start-Process -FilePath $script:VxKexInstallerPath -ArgumentList "/VERYSILENT", "/NORESTART" -Wait -PassThru

        if ($process.ExitCode -eq 0) {
            Add-Log "✓ VxKex 安装成功"
            return $true
        } else {
            Add-Log "❌ VxKex 安装失败 (退出代码: $($process.ExitCode))"
            return $false
        }
    } catch {
        Add-Log "❌ 安装 VxKex 时出错: $($_.Exception.Message)"
        return $false
    }
}

# 配置 Clash Verge 兼容性
function Set-ClashVergeCompatibility {
    param([string]$exePath)

    Add-Log "配置 Clash Verge 兼容性设置..."

    if (-not (Test-Path $exePath)) {
        Add-Log "❌ 错误: 找不到 Clash Verge 可执行文件"
        return $false
    }

    try {
        # 获取注册表路径
        $regPath = "HKCU:\Software\VXsoft\VxKex\Configured"
        $exeName = Split-Path $exePath -Leaf

        # 确保注册表路径存在
        if (-not (Test-Path $regPath)) {
            Add-Log "创建注册表路径: $regPath"
            New-Item -Path $regPath -Force | Out-Null
        }

        # 设置 VxKex 配置
        Add-Log "设置 VxKex 配置..."
        Set-ItemProperty -Path $regPath -Name $exeName -Value 1 -Type DWord -Force

        # 设置兼容性标志
        $compatPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
        if (-not (Test-Path $compatPath)) {
            Add-Log "创建兼容性设置路径..."
            New-Item -Path $compatPath -Force | Out-Null
        }

        Add-Log "应用 Windows 7 兼容模式..."
        Set-ItemProperty -Path $compatPath -Name $exePath -Value "~ WIN7RTM VXKEX" -Type String -Force

        Add-Log "✓ 兼容性设置配置成功"
        return $true
    } catch {
        Add-Log "❌ 配置兼容性时出错: $($_.Exception.Message)"
        return $false
    }
}

# 主配置流程
function Start-Configuration {
    # 禁用按钮
    $configButton.Enabled = $false
    $browseButton.Enabled = $false
    $progressTextBox.Clear()

    try {
        # 检查管理员权限
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

        # 检查是否选择了路径
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

        Add-Log "=" * 50
        Add-Log "开始配置 Clash Verge VxKex 兼容性"
        Add-Log "=" * 50

        $statusLabel.Text = "⏳ 正在安装 VxKex..."
        $statusLabel.ForeColor = [System.Drawing.Color]::Blue

        # 步骤 1: 安装 VxKex
        if (-not (Install-VxKex)) {
            throw "VxKex 安装失败"
        }

        Start-Sleep -Seconds 2

        $statusLabel.Text = "⏳ 正在配置兼容性设置..."

        # 步骤 2: 配置兼容性
        if (-not (Set-ClashVergeCompatibility -exePath $script:ClashVergeExePath)) {
            throw "兼容性配置失败"
        }

        Add-Log ""
        Add-Log "=" * 50
        Add-Log "✅ 配置完成！"
        Add-Log "=" * 50
        Add-Log ""
        Add-Log "现在可以正常启动 Clash Verge 了！"

        $statusLabel.Text = "✅ 配置成功！现在可以启动 Clash Verge 了"
        $statusLabel.ForeColor = [System.Drawing.Color]::Green

        [System.Windows.Forms.MessageBox]::Show(
            "✅ 配置成功！`n`nClash Verge 现在可以在 Windows 7 上正常运行了。`n`n请启动 Clash Verge 测试。",
            "配置完成",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )

    } catch {
        Add-Log ""
        Add-Log "❌ 配置失败: $($_.Exception.Message)"
        $statusLabel.Text = "❌ 配置失败，请查看详细日志"
        $statusLabel.ForeColor = [System.Drawing.Color]::Red

        [System.Windows.Forms.MessageBox]::Show(
            "配置失败！`n`n错误: $($_.Exception.Message)`n`n请查看详细日志了解更多信息。",
            "配置失败",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
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
