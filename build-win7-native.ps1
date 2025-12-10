# Clash Verge VxKex Configurator - Windows 7 原生打包脚本
# 使用 Windows 7 自带的 IExpress 工具打包成单个 EXE
# 适用于 Windows 7 SP1 及以上版本

param(
    [switch]$Clean = $false
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Clash Verge VxKex Configurator - Windows 7 原生打包  " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否在 Windows 上运行
if ($PSVersionTable.Platform -and $PSVersionTable.Platform -ne "Win32NT") {
    Write-Host "❌ 错误: 此脚本只能在 Windows 系统上运行" -ForegroundColor Red
    exit 1
}

# 检查必需文件
Write-Host "[1/5] 检查必需文件..." -ForegroundColor Yellow
$requiredFiles = @(
    "ClashVerge-VxKex-Configurator.bat",
    "VxKexConfigurator.ps1",
    "resources\KexSetup_Release_1_1_2_1428.exe"
)

$allFilesExist = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "  ✓ $file" -ForegroundColor Green
    } else {
        Write-Host "  ❌ 文件不存在: $file" -ForegroundColor Red
        $allFilesExist = $false
    }
}

if (-not $allFilesExist) {
    Write-Host ""
    Write-Host "❌ 缺少必需文件，无法继续构建" -ForegroundColor Red
    exit 1
}
Write-Host ""

# 创建输出目录
Write-Host "[2/5] 准备输出目录..." -ForegroundColor Yellow
if (-not (Test-Path "dist")) {
    New-Item -ItemType Directory -Path "dist" | Out-Null
    Write-Host "  ✓ 创建 dist 目录" -ForegroundColor Green
} else {
    Write-Host "  ✓ dist 目录已存在" -ForegroundColor Green
}

# 清理旧文件
if ($Clean -or (Test-Path "dist\ClashVerge-VxKex-Configurator.exe")) {
    Write-Host "  清理旧的构建文件..." -ForegroundColor Gray
    Remove-Item "dist\ClashVerge-VxKex-Configurator.exe" -Force -ErrorAction SilentlyContinue
}
Write-Host ""

# 创建临时 SED 配置文件（动态生成绝对路径）
Write-Host "[3/5] 生成 IExpress 配置文件..." -ForegroundColor Yellow
$currentDir = (Get-Location).Path
$targetExe = Join-Path $currentDir "dist\ClashVerge-VxKex-Configurator.exe"

$sedContent = @"
[Version]
Class=IEXPRESS
SEDVersion=3

[Options]
PackagePurpose=InstallApp
ShowInstallProgramWindow=0
HideExtractAnimation=1
UseLongFileName=1
InsideCompressed=0
CAB_FixedSize=0
CAB_ResvCodeSigning=0
RebootMode=N
InstallPrompt=Clash Verge VxKex 配置工具将解压并运行。此工具需要管理员权限。是否继续？
DisplayLicense=
FinishMessage=配置工具已启动，请在 GUI 窗口中完成配置。
TargetName=$targetExe
FriendlyName=Clash Verge VxKex Configurator for Windows 7
AppLaunched=cmd.exe /c ClashVerge-VxKex-Configurator.bat
PostInstallCmd=<None>
AdminQuietInstCmd=
UserQuietInstCmd=
SourceFiles=SourceFiles

[SourceFiles]
SourceFiles0=$currentDir
SourceFiles1=$currentDir\resources

[SourceFiles0]
ClashVerge-VxKex-Configurator.bat=
VxKexConfigurator.ps1=

[SourceFiles1]
KexSetup_Release_1_1_2_1428.exe=
"@

$tempSedFile = "dist\temp_build.sed"
[System.IO.File]::WriteAllText($tempSedFile, $sedContent, [System.Text.Encoding]::Default)
Write-Host "  ✓ SED 配置文件已生成" -ForegroundColor Green
Write-Host "  路径: $tempSedFile" -ForegroundColor Gray
Write-Host ""

# 查找 IExpress
Write-Host "[4/5] 查找 IExpress..." -ForegroundColor Yellow
$iexpressPath = "$env:SystemRoot\System32\iexpress.exe"
if (-not (Test-Path $iexpressPath)) {
    Write-Host "  ❌ 错误: 找不到 IExpress.exe" -ForegroundColor Red
    Write-Host "  IExpress 是 Windows 自带工具，通常位于: $iexpressPath" -ForegroundColor Yellow
    exit 1
}
Write-Host "  ✓ 找到 IExpress: $iexpressPath" -ForegroundColor Green
Write-Host ""

# 执行 IExpress 打包
Write-Host "[5/5] 执行 IExpress 打包..." -ForegroundColor Yellow
Write-Host "  这可能需要几秒钟，请稍候..." -ForegroundColor Gray
Write-Host ""

try {
    Write-Host "  IExpress 路径: $iexpressPath" -ForegroundColor Gray
    Write-Host "  SED 文件路径: $tempSedFile" -ForegroundColor Gray
    Write-Host "  目标 EXE 路径: $targetExe" -ForegroundColor Gray
    Write-Host ""

    # 使用 /N 参数进行静默打包，捕获输出
    Write-Host "  正在执行 IExpress..." -ForegroundColor Gray
    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = $iexpressPath
    $processInfo.Arguments = "/N `"$tempSedFile`""
    $processInfo.UseShellExecute = $false
    $processInfo.RedirectStandardOutput = $true
    $processInfo.RedirectStandardError = $true
    $processInfo.CreateNoWindow = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $processInfo

    $stdout = New-Object System.Text.StringBuilder
    $stderr = New-Object System.Text.StringBuilder

    $process.OutputDataReceived += {
        if ($EventArgs.Data) {
            [void]$stdout.AppendLine($EventArgs.Data)
            Write-Host "  [OUT] $($EventArgs.Data)" -ForegroundColor Gray
        }
    }
    $process.ErrorDataReceived += {
        if ($EventArgs.Data) {
            [void]$stderr.AppendLine($EventArgs.Data)
            Write-Host "  [ERR] $($EventArgs.Data)" -ForegroundColor Red
        }
    }

    [void]$process.Start()
    $process.BeginOutputReadLine()
    $process.BeginErrorReadLine()
    $process.WaitForExit()

    $exitCode = $process.ExitCode
    Write-Host ""
    Write-Host "  IExpress 退出代码: $exitCode" -ForegroundColor $(if ($exitCode -eq 0) { "Green" } else { "Red" })

    if ($exitCode -eq 0) {
        # 等待文件系统同步
        Start-Sleep -Seconds 2

        if (Test-Path $targetExe) {
            Write-Host "  ✓ IExpress 打包成功！" -ForegroundColor Green
        } else {
            Write-Host "  ❌ IExpress 执行成功但未找到输出文件" -ForegroundColor Red
            Write-Host "  预期路径: $targetExe" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "  检查 dist 目录内容:" -ForegroundColor Yellow
            if (Test-Path "dist") {
                Get-ChildItem "dist" -Force | ForEach-Object {
                    Write-Host "    - $($_.Name)" -ForegroundColor Gray
                }
            } else {
                Write-Host "    dist 目录不存在" -ForegroundColor Red
            }
            exit 1
        }
    } else {
        Write-Host "  ❌ IExpress 打包失败" -ForegroundColor Red
        if ($stderr.Length -gt 0) {
            Write-Host ""
            Write-Host "  错误输出:" -ForegroundColor Red
            Write-Host $stderr.ToString() -ForegroundColor Red
        }
        exit 1
    }
} catch {
    Write-Host "  ❌ 执行 IExpress 时出错: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "  堆栈跟踪: $($_.ScriptStackTrace)" -ForegroundColor Red
    exit 1
}

# 清理临时文件
Remove-Item $tempSedFile -Force -ErrorAction SilentlyContinue

# 显示结果
Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "                    构建完成！                          " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""

$exeInfo = Get-Item $targetExe
$sizeInMB = [math]::Round($exeInfo.Length / 1MB, 2)

Write-Host "输出文件信息:" -ForegroundColor Yellow
Write-Host "  文件名: ClashVerge-VxKex-Configurator.exe" -ForegroundColor Cyan
Write-Host "  路径: $targetExe" -ForegroundColor Cyan
Write-Host "  大小: $sizeInMB MB" -ForegroundColor Cyan
Write-Host "  创建时间: $($exeInfo.CreationTime)" -ForegroundColor Cyan
Write-Host ""

Write-Host "使用方法:" -ForegroundColor Yellow
Write-Host "  1. 将 ClashVerge-VxKex-Configurator.exe 复制到 Windows 7 机器" -ForegroundColor White
Write-Host "  2. 右键点击 EXE 文件" -ForegroundColor White
Write-Host "  3. 选择'以管理员身份运行'" -ForegroundColor White
Write-Host "  4. 在 GUI 中选择 Clash Verge 路径并点击'一键启用 VxKex'" -ForegroundColor White
Write-Host ""

Write-Host "目标系统: Windows 7 SP1 及以上版本" -ForegroundColor Gray
Write-Host ""
Write-Host "✅ 打包完成！可以分发给用户使用了。" -ForegroundColor Green
Write-Host ""
