# 清理旧的 Git Tags 和 GitHub Releases
# 用于删除所有旧版本的 tag 和 release，为新版本做准备

param(
    [switch]$DryRun = $false,
    [switch]$Force = $false
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  清理旧的 Git Tags 和 GitHub Releases                  " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "⚠️  DRY RUN 模式 - 只显示将要删除的内容，不会实际删除" -ForegroundColor Yellow
    Write-Host ""
}

# 检查是否在 git 仓库中
if (-not (Test-Path ".git")) {
    Write-Host "❌ 错误: 当前目录不是 git 仓库" -ForegroundColor Red
    exit 1
}

# 获取所有本地 tag
Write-Host "[1/4] 获取本地 tags..." -ForegroundColor Yellow
$localTags = git tag -l
if ($localTags) {
    Write-Host "  找到 $($localTags.Count) 个本地 tag:" -ForegroundColor Cyan
    foreach ($tag in $localTags) {
        Write-Host "    - $tag" -ForegroundColor Gray
    }
} else {
    Write-Host "  没有找到本地 tag" -ForegroundColor Gray
}
Write-Host ""

# 获取所有远程 tag
Write-Host "[2/4] 获取远程 tags..." -ForegroundColor Yellow
git fetch --tags 2>&1 | Out-Null
$remoteTags = git ls-remote --tags origin | ForEach-Object {
    if ($_ -match 'refs/tags/(.+)$') {
        $matches[1] -replace '\^\{\}$', ''
    }
} | Select-Object -Unique

if ($remoteTags) {
    Write-Host "  找到 $($remoteTags.Count) 个远程 tag:" -ForegroundColor Cyan
    foreach ($tag in $remoteTags) {
        Write-Host "    - $tag" -ForegroundColor Gray
    }
} else {
    Write-Host "  没有找到远程 tag" -ForegroundColor Gray
}
Write-Host ""

# 确认操作
if (-not $Force -and -not $DryRun) {
    Write-Host "⚠️  警告: 此操作将删除所有本地和远程的 tags！" -ForegroundColor Red
    Write-Host ""
    Write-Host "将要删除的 tags:" -ForegroundColor Yellow
    $allTags = @($localTags) + @($remoteTags) | Select-Object -Unique
    foreach ($tag in $allTags) {
        Write-Host "  - $tag" -ForegroundColor Gray
    }
    Write-Host ""

    $confirm = Read-Host "确定要继续吗？(输入 'YES' 确认)"
    if ($confirm -ne "YES") {
        Write-Host ""
        Write-Host "❌ 操作已取消" -ForegroundColor Yellow
        exit 0
    }
    Write-Host ""
}

# 删除本地 tag
Write-Host "[3/4] 删除本地 tags..." -ForegroundColor Yellow
if ($localTags) {
    foreach ($tag in $localTags) {
        if ($DryRun) {
            Write-Host "  [DRY RUN] 将删除本地 tag: $tag" -ForegroundColor Gray
        } else {
            Write-Host "  删除本地 tag: $tag" -ForegroundColor Gray
            git tag -d $tag 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "    ✓ 已删除" -ForegroundColor Green
            } else {
                Write-Host "    ❌ 删除失败" -ForegroundColor Red
            }
        }
    }
} else {
    Write-Host "  没有需要删除的本地 tag" -ForegroundColor Gray
}
Write-Host ""

# 删除远程 tag
Write-Host "[4/4] 删除远程 tags..." -ForegroundColor Yellow
if ($remoteTags) {
    foreach ($tag in $remoteTags) {
        if ($DryRun) {
            Write-Host "  [DRY RUN] 将删除远程 tag: $tag" -ForegroundColor Gray
        } else {
            Write-Host "  删除远程 tag: $tag" -ForegroundColor Gray
            git push origin --delete $tag 2>&1 | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "    ✓ 已删除" -ForegroundColor Green
            } else {
                Write-Host "    ❌ 删除失败（可能需要权限或 tag 已不存在）" -ForegroundColor Yellow
            }
        }
    }
} else {
    Write-Host "  没有需要删除的远程 tag" -ForegroundColor Gray
}
Write-Host ""

# 显示 GitHub Releases 清理说明
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  GitHub Releases 清理说明                             " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "⚠️  注意: 删除 tags 不会自动删除 GitHub Releases" -ForegroundColor Yellow
Write-Host ""
Write-Host "要删除 GitHub Releases，请执行以下操作之一：" -ForegroundColor Yellow
Write-Host ""
Write-Host "方法 1: 使用 GitHub Web 界面" -ForegroundColor Cyan
Write-Host "  1. 访问: https://github.com/z0fans/clash-verge-vxkex-tool/releases" -ForegroundColor Gray
Write-Host "  2. 点击每个 Release 的'Delete'按钮" -ForegroundColor Gray
Write-Host ""
Write-Host "方法 2: 使用 GitHub CLI (gh)" -ForegroundColor Cyan
Write-Host "  安装 gh: https://cli.github.com/" -ForegroundColor Gray
Write-Host "  然后运行:" -ForegroundColor Gray
Write-Host ""
Write-Host "    gh auth login" -ForegroundColor White
Write-Host "    gh release list --repo z0fans/clash-verge-vxkex-tool" -ForegroundColor White
Write-Host "    gh release delete <tag> --repo z0fans/clash-verge-vxkex-tool --yes" -ForegroundColor White
Write-Host ""

if ($DryRun) {
    Write-Host "✓ DRY RUN 完成 - 未进行实际删除" -ForegroundColor Green
} else {
    Write-Host "✓ Tags 清理完成！" -ForegroundColor Green
}

Write-Host ""
Write-Host "下一步:" -ForegroundColor Yellow
Write-Host "  1. 清理 GitHub Releases（见上方说明）" -ForegroundColor Gray
Write-Host "  2. 提交新代码: git add . && git commit -m 'feat: Windows native IExpress packaging'" -ForegroundColor Gray
Write-Host "  3. 推送代码: git push origin main" -ForegroundColor Gray
Write-Host "  4. 创建新 tag: git tag v4.0.0 && git push origin v4.0.0" -ForegroundColor Gray
Write-Host ""
