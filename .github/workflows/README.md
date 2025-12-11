# VxKex 自动化构建与发布系统

## 🚀 功能特性

本 GitHub Actions 工作流提供了完整的 VxKex 自动化构建和发布解决方案:

### ✨ 核心功能

1. **自动化编译**
   - 支持 x86 (Win32) 和 x64 双平台构建
   - 使用 Visual Studio 2019 工具链
   - 完整的 MSBuild 构建流程

2. **智能打包**
   - Inno Setup 安装程序 (支持静默安装)
   - 便携版 ZIP 压缩包 (x86 + x64)
   - SHA256 校验和自动生成

3. **Clash Verge 自动配置**
   - 自动检测 Clash Verge 安装位置
   - 为 4 个关键文件配置 VxKex 支持
   - 完全无需用户手动操作

4. **版本管理与发布**
   - 基于 Git 标签的版本控制
   - 自动创建 GitHub Releases
   - 构建产物自动上传

---

## 📋 使用方法

### 方式 1: 通过 Git 标签自动触发 (推荐)

这是最标准的发布方式,适用于正式版本发布:

```bash
# 1. 提交所有更改
git add .
git commit -m "Release version 1.1.4.0"

# 2. 创建并推送标签 (格式: v主版本.次版本.补丁.构建号)
git tag v1.1.4.0
git push origin v1.1.4.0

# 3. GitHub Actions 自动启动构建流程
# 构建完成后会自动创建 Release 并上传安装包
```

### 方式 2: 手动触发构建

适用于测试或特殊情况:

1. 访问你的 GitHub 仓库
2. 点击 **Actions** 标签
3. 选择 **Build and Release VxKex** 工作流
4. 点击 **Run workflow** 按钮
5. 输入版本号 (例如: `1.1.3.1428`)
6. 点击 **Run workflow** 确认

---

## 📦 构建产物说明

每次构建会生成以下文件:

| 文件名 | 说明 | 适用场景 |
|--------|------|----------|
| `VxKex-{版本}-Setup.exe` | 完整安装程序 | 推荐给普通用户,支持静默安装 |
| `VxKex-{版本}-Portable-x86.zip` | x86 便携版 | 32位系统或需要便携使用 |
| `VxKex-{版本}-Portable-x64.zip` | x64 便携版 | 64位系统便携使用 |
| `*.sha256` | 校验和文件 | 验证文件完整性 |

### 下载位置

- **标签触发**: 在 GitHub Releases 页面下载
- **手动触发**: 在 Actions 页面的 Artifacts 中下载 (保留 30 天)

---

## 🔐 代码签名 (可选)

为了提升用户信任度,建议为安装程序添加数字签名。

### 配置步骤

#### 1. 获取代码签名证书

你需要从 CA 机构购买代码签名证书 (推荐供应商):
- **DigiCert** - 业界标准,最受信任
- **Sectigo (原 Comodo)** - 性价比高
- **GlobalSign** - 国际认可

**证书类型**: EV Code Signing Certificate (推荐) 或 Standard Code Signing

#### 2. 导出 PFX 证书

将证书导出为 `.pfx` 格式,并设置强密码:

```bash
# Windows: 使用证书管理器导出
certmgr.msc -> 导出 -> 选择 "是,导出私钥" -> PFX 格式
```

#### 3. 将证书转换为 Base64

```powershell
# PowerShell
$CertBytes = [System.IO.File]::ReadAllBytes("C:\Path\To\Certificate.pfx")
$CertBase64 = [System.Convert]::ToBase64String($CertBytes)
$CertBase64 | Out-File -FilePath "cert-base64.txt"
```

#### 4. 配置 GitHub Secrets

在你的 GitHub 仓库中添加以下 Secrets:

1. 进入 **Settings** → **Secrets and variables** → **Actions**
2. 添加以下 Secrets:

| Secret 名称 | 值 | 说明 |
|------------|-------|------|
| `CERTIFICATE_BASE64` | Base64 编码的证书 | 从上一步生成的 cert-base64.txt 复制 |
| `CERTIFICATE_PASSWORD` | 证书密码 | 导出 PFX 时设置的密码 |

#### 5. 修改工作流添加签名步骤

在 `.github/workflows/build-release.yml` 中的 "Compile Installer" 步骤后添加:

```yaml
    # ========== 代码签名 (可选) ==========
    - name: Sign Installer
      if: ${{ secrets.CERTIFICATE_BASE64 != '' }}
      shell: pwsh
      run: |
        # 解码证书
        $CertBytes = [System.Convert]::FromBase64String("${{ secrets.CERTIFICATE_BASE64 }}")
        $CertPath = "$env:TEMP\certificate.pfx"
        [System.IO.File]::WriteAllBytes($CertPath, $CertBytes)

        # 查找签名工具
        $SignToolPath = Get-ChildItem -Path "C:\Program Files (x86)\Windows Kits" -Recurse -Filter "signtool.exe" |
          Sort-Object LastWriteTime -Descending | Select-Object -First 1

        if (-not $SignToolPath) {
          Write-Error "signtool.exe not found"
          exit 1
        }

        # 签名所有安装程序
        Get-ChildItem -Filter "VxKex-*-Setup.exe" | ForEach-Object {
          Write-Host "Signing: $($_.Name)"

          & $SignToolPath.FullName sign `
            /f $CertPath `
            /p "${{ secrets.CERTIFICATE_PASSWORD }}" `
            /tr http://timestamp.digicert.com `
            /td SHA256 `
            /fd SHA256 `
            /v `
            $_.FullName

          if ($LASTEXITCODE -ne 0) {
            Write-Error "Failed to sign $($_.Name)"
            exit 1
          }
        }

        # 清理证书文件
        Remove-Item $CertPath -Force
        Write-Host "All installers signed successfully"
```

---

## 🛠️ 高级配置

### 自定义 Clash Verge 检测路径

如果需要添加更多检测路径,编辑工作流中的 `FindClashVergeInstallPath` 函数:

```pascal
// 添加自定义路径
DefaultPath := 'D:\CustomPath\Clash Verge';
if DirExists(DefaultPath) then
begin
  Result := DefaultPath;
  Exit;
end;
```

### 修改构建配置

在工作流文件的 `env` 段修改:

```yaml
env:
  SOLUTION_NAME: VxKex.sln
  BUILD_CONFIGURATION: Release  # Debug 或 Release
```

### 添加更多平台支持

目前支持 Win32 和 x64,如需添加 ARM64:

```yaml
- name: Build ARM64
  run: |
    msbuild ${{ env.SOLUTION_NAME }} `
      /p:Configuration=${{ env.BUILD_CONFIGURATION }} `
      /p:Platform=ARM64 `
      /m `
      /v:minimal
```

---

## 🐛 故障排查

### 问题 1: 编译失败

**原因**: 缺少依赖或项目文件配置错误

**解决方案**:
1. 检查 `.sln` 和 `.vcxproj` 文件是否正确
2. 确认所有依赖项已提交到仓库
3. 查看 Actions 日志中的详细错误信息

### 问题 2: Inno Setup 脚本错误

**原因**: 文件路径不存在或权限问题

**解决方案**:
1. 检查 `PackageRoot` 目录是否正确创建
2. 确认所有必需的 DLL/EXE 已编译
3. 验证 Inno Setup 脚本语法

### 问题 3: 签名失败

**原因**: 证书密码错误或证书已过期

**解决方案**:
1. 验证 `CERTIFICATE_PASSWORD` Secret 是否正确
2. 检查证书有效期
3. 确认证书格式为 PFX

### 问题 4: Release 未自动创建

**原因**: 标签格式不正确或权限不足

**解决方案**:
1. 确保标签格式为 `v1.2.3` (以 v 开头)
2. 检查 `GITHUB_TOKEN` 权限
3. 手动创建 Release 后重新推送标签

---

## 📊 工作流状态徽章

在你的 `README.md` 中添加构建状态徽章:

```markdown
[![Build Status](https://github.com/YOUR_USERNAME/VxKex/actions/workflows/build-release.yml/badge.svg)](https://github.com/YOUR_USERNAME/VxKex/actions)
```

---

## 📝 版本号命名规范

建议遵循以下版本号格式:

```
v主版本.次版本.修订号.构建号
```

示例:
- `v1.1.3.1428` - 稳定版本
- `v1.2.0.0` - 新功能版本
- `v1.1.3.1500-beta` - 测试版本

---

## 🤝 贡献指南

如需改进构建流程:

1. Fork 本仓库
2. 创建功能分支: `git checkout -b feature/build-improvement`
3. 提交更改: `git commit -m "Improve build process"`
4. 推送到分支: `git push origin feature/build-improvement`
5. 提交 Pull Request

---

## 📄 许可证

本构建配置遵循 VxKex 项目的许可证。

---

## 🙏 致谢

- **Inno Setup** - 优秀的安装程序制作工具
- **GitHub Actions** - 强大的 CI/CD 平台
- **Microsoft MSBuild** - 可靠的构建系统
