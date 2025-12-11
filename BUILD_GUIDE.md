# VxKex 构建与发布完整指南

本文档包含 VxKex 项目的完整构建、打包和发布流程。

---

## 📋 目录

1. [本地构建](#本地构建)
2. [GitHub Actions 自动化构建](#github-actions-自动化构建)
3. [代码签名](#代码签名)
4. [发布流程](#发布流程)
5. [故障排查](#故障排查)

---

## 🔨 本地构建

### 环境准备

**必需软件:**
- Visual Studio 2010 或更高版本
- Windows SDK (通常随 VS 安装)
- Git (用于版本控制)

**可选软件:**
- Inno Setup 6 (用于创建安装程序)

### 构建步骤

#### 1. 克隆仓库

```bash
git clone https://github.com/i486/VxKex.git
cd VxKex
```

#### 2. 使用 Visual Studio 构建

**图形界面方式:**
1. 双击打开 `VxKex.sln`
2. 选择构建配置 (Release)
3. 选择平台 (Win32 或 x64)
4. 点击 **生成** → **生成解决方案**

**命令行方式:**

```cmd
:: 构建 x86 版本
msbuild VxKex.sln /p:Configuration=Release /p:Platform=Win32 /m

:: 构建 x64 版本
msbuild VxKex.sln /p:Configuration=Release /p:Platform=x64 /m
```

#### 3. 查找构建产物

编译完成后,产物位于:
- **x86**: `.\Release\` 目录
- **x64**: `.\x64\Release\` 目录

主要文件:
- `KexDll.dll` - 核心注入 DLL
- `VxKexLdr.exe` - 加载器
- `KexCfg.exe` - 配置工具
- `KexGui.dll` - GUI 库
- `KxBase.dll`, `KxUser.dll` 等 - API 扩展 DLL

---

## 🤖 GitHub Actions 自动化构建

GitHub Actions 工作流已配置完毕,位于 `.github/workflows/build-release.yml`。

### 触发构建的两种方式

#### 方式 1: 推送标签 (自动发布)

```bash
# 创建版本标签
git tag v1.1.4.0

# 推送到 GitHub
git push origin v1.1.4.0
```

**结果:**
- 自动构建 x86 + x64 版本
- 自动创建安装程序
- 自动创建便携版 ZIP
- 自动创建 GitHub Release
- 自动上传所有构建产物

#### 方式 2: 手动触发 (测试构建)

1. 访问 GitHub 仓库
2. 点击 **Actions** 标签
3. 选择 **Build and Release VxKex**
4. 点击 **Run workflow**
5. 输入版本号
6. 点击 **Run workflow** 确认

**结果:**
- 构建产物保存在 Artifacts (30天)
- 不会创建 Release
- 适合测试和验证

### 工作流程概览

```
1. 检出代码
2. 设置 MSBuild 环境
3. 恢复 NuGet 包
4. 构建 x86 版本 (约 3-5 分钟)
5. 构建 x64 版本 (约 3-5 分钟)
6. 收集构建产物
7. 安装 Inno Setup
8. 生成安装程序脚本 (包含 Clash Verge 自动配置)
9. 编译安装程序 (约 1-2 分钟)
10. 创建便携版压缩包
11. 生成 SHA256 校验和
12. 上传构建产物
13. 创建 GitHub Release (仅标签触发)
```

**总计时间**: 约 10-15 分钟

---

## 🔐 代码签名

代码签名可以提升用户信任度,减少 Windows SmartScreen 警告。

### 步骤 1: 获取证书

推荐的证书供应商:

| 供应商 | 价格/年 | 说明 |
|--------|---------|------|
| DigiCert | $400-500 | 业界标准,最受信任 |
| Sectigo (Comodo) | $200-300 | 性价比高 |
| GlobalSign | $300-400 | 国际认可 |

**证书类型选择:**
- **EV Code Signing** (推荐): 立即获得 SmartScreen 信誉
- **Standard Code Signing**: 需要积累信誉

### 步骤 2: 导出 PFX 证书

**Windows 证书管理器方式:**
1. 按 `Win+R`,输入 `certmgr.msc`
2. 找到你的代码签名证书
3. 右键 → **所有任务** → **导出**
4. 选择 **是,导出私钥**
5. 选择 **个人信息交换 (PFX)**
6. 设置强密码
7. 保存为 `certificate.pfx`

### 步骤 3: 配置 GitHub Secrets

1. 将证书转换为 Base64:

```powershell
# PowerShell
$CertBytes = [System.IO.File]::ReadAllBytes("certificate.pfx")
$CertBase64 = [System.Convert]::ToBase64String($CertBytes)
$CertBase64 | Out-File "cert-base64.txt"
```

2. 在 GitHub 仓库中添加 Secrets:

   - 进入 **Settings** → **Secrets and variables** → **Actions**
   - 添加 `CERTIFICATE_BASE64` (粘贴 cert-base64.txt 内容)
   - 添加 `CERTIFICATE_PASSWORD` (证书密码)

### 步骤 4: 启用签名

编辑 `.github/workflows/build-release.yml`,在 "Compile Installer" 后添加:

```yaml
    - name: Sign Installer
      if: ${{ secrets.CERTIFICATE_BASE64 != '' }}
      shell: pwsh
      run: |
        $CertBytes = [System.Convert]::FromBase64String("${{ secrets.CERTIFICATE_BASE64 }}")
        $CertPath = "$env:TEMP\certificate.pfx"
        [System.IO.File]::WriteAllBytes($CertPath, $CertBytes)

        $SignTool = (Get-ChildItem -Path "C:\Program Files (x86)\Windows Kits" `
          -Recurse -Filter "signtool.exe" |
          Sort-Object LastWriteTime -Descending |
          Select-Object -First 1).FullName

        Get-ChildItem -Filter "VxKex-*-Setup.exe" | ForEach-Object {
          & $SignTool sign `
            /f $CertPath `
            /p "${{ secrets.CERTIFICATE_PASSWORD }}" `
            /tr http://timestamp.digicert.com `
            /td SHA256 `
            /fd SHA256 `
            /v `
            $_.FullName
        }

        Remove-Item $CertPath -Force
```

### 验证签名

签名后,右键点击 `.exe` 文件 → **属性** → **数字签名** 标签,应该能看到签名信息。

---

## 📦 发布流程

### 标准发布检查清单

- [ ] 所有代码已提交并推送
- [ ] 版本号已更新 (在 `KexVer.h` 或相关文件中)
- [ ] CHANGELOG 已更新
- [ ] 所有测试通过
- [ ] 本地构建验证成功
- [ ] 准备好 Release Notes

### 发布步骤

#### 1. 准备 Release Notes

复制 `.github/RELEASE_TEMPLATE.md` 并填写:
- 版本号
- 新特性列表
- Bug 修复列表
- 已知问题

#### 2. 创建并推送标签

```bash
# 确保在 main 分支
git checkout main
git pull

# 创建标签
git tag -a v1.1.4.0 -m "Release version 1.1.4.0"

# 推送标签
git push origin v1.1.4.0
```

#### 3. 监控构建过程

1. 访问 **Actions** 页面
2. 查看工作流执行状态
3. 如有错误,查看日志并修复

#### 4. 完善 Release 信息

构建完成后:
1. 访问 **Releases** 页面
2. 找到自动创建的 Release
3. 点击 **Edit**
4. 粘贴准备好的 Release Notes
5. 验证所有文件已上传
6. 点击 **Update release**

#### 5. 宣布发布

- 在项目 README 中更新最新版本链接
- 在相关社区发布更新公告
- 通知 Issue 中等待修复的用户

---

## 🐛 故障排查

### 问题 1: MSBuild 找不到项目文件

**症状:**
```
error MSB4019: The imported project "C:\xxx.props" was not found
```

**解决方案:**
1. 检查 `.vcxproj` 文件中的导入路径
2. 确保所有依赖文件已提交到仓库
3. 验证 Visual Studio 版本兼容性

### 问题 2: Inno Setup 编译失败

**症状:**
```
Error on line X: Source file not found
```

**解决方案:**
1. 检查 `PackageRoot` 目录是否正确创建
2. 验证所有 DLL/EXE 已成功编译
3. 检查文件路径大小写 (Linux/macOS 区分大小写)

### 问题 3: 签名失败

**症状:**
```
SignTool Error: The specified PFX password is not correct
```

**解决方案:**
1. 验证 `CERTIFICATE_PASSWORD` Secret 值
2. 重新导出证书并确认密码
3. 检查证书是否过期

### 问题 4: GitHub Actions 权限错误

**症状:**
```
Resource not accessible by integration
```

**解决方案:**
1. 进入 **Settings** → **Actions** → **General**
2. 在 "Workflow permissions" 中选择 **Read and write permissions**
3. 勾选 **Allow GitHub Actions to create and approve pull requests**

### 问题 5: Release 创建失败

**症状:**
工作流成功但未创建 Release

**解决方案:**
1. 确认标签格式为 `v*.*.*` (以 v 开头)
2. 检查是否已存在同名 Release
3. 验证 `GITHUB_TOKEN` 权限
4. 查看工作流中的 `if: startsWith(github.ref, 'refs/tags/')` 条件

---

## 📊 构建优化

### 加速本地构建

```cmd
:: 使用多核编译
msbuild VxKex.sln /p:Configuration=Release /p:Platform=x64 /m:8

:: 仅构建特定项目
msbuild KexDll\KexDll.vcxproj /p:Configuration=Release /p:Platform=x64
```

### 减小安装包体积

在 Inno Setup 脚本中调整:

```pascal
; 最大压缩 (慢但小)
Compression=lzma2/ultra64
SolidCompression=yes

; 快速压缩 (快但大)
Compression=lzma2/fast

; 平衡 (推荐)
Compression=lzma2/normal
```

### GitHub Actions 缓存

添加 NuGet 缓存加速构建:

```yaml
- name: Cache NuGet
  uses: actions/cache@v3
  with:
    path: ~/.nuget/packages
    key: ${{ runner.os }}-nuget-${{ hashFiles('**/*.sln') }}
```

---

## 📚 附加资源

- [Inno Setup 官方文档](https://jrsoftware.org/ishelp/)
- [MSBuild 参考](https://docs.microsoft.com/en-us/visualstudio/msbuild/)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [代码签名最佳实践](https://docs.microsoft.com/en-us/windows-hardware/drivers/install/authenticode)

---

## 🤝 贡献

改进构建流程的建议欢迎通过 Pull Request 提交!

---

**祝构建顺利!** 🚀
