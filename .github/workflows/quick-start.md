# VxKex 自动化打包 - 快速开始指南

## 🎯 5分钟快速上手

### 前置条件

- ✅ 拥有一个 GitHub 账号
- ✅ 已 fork 或创建了 VxKex 仓库
- ✅ 项目代码已推送到 GitHub

---

## 📝 第一次发布的完整步骤

### 步骤 1: 提交工作流文件

将已创建的文件提交到仓库:

```bash
# 进入项目目录
cd /path/to/VxKex

# 添加工作流配置文件
git add .github/workflows/

# 提交
git commit -m "Add automated build and release workflow"

# 推送到 GitHub
git push origin main
```

### 步骤 2: 创建第一个发布版本

```bash
# 创建版本标签 (根据实际版本号修改)
git tag v1.1.3.1428

# 推送标签到 GitHub
git push origin v1.1.3.1428
```

### 步骤 3: 查看构建进度

1. 打开你的 GitHub 仓库页面
2. 点击顶部的 **Actions** 标签
3. 你会看到一个正在运行的工作流 "Build and Release VxKex"
4. 点击进入查看详细日志

**预计构建时间**: 10-15 分钟 (取决于项目大小)

### 步骤 4: 下载构建产物

构建完成后:

1. 点击顶部的 **Releases** 标签
2. 你会看到新创建的 Release (版本号: v1.1.3.1428)
3. 下载以下文件:
   - `VxKex-1.1.3.1428-Setup.exe` - 安装程序
   - `VxKex-1.1.3.1428-Portable-x64.zip` - 64位便携版
   - `VxKex-1.1.3.1428-Portable-x86.zip` - 32位便携版

---

## 🔄 日常发布流程

### 场景 1: 发布新版本

```bash
# 1. 更新代码
git add .
git commit -m "Fix bug in KexDll"

# 2. 推送到 GitHub
git push origin main

# 3. 创建新版本标签
git tag v1.1.4.0
git push origin v1.1.4.0

# 4. 等待自动构建完成
```

### 场景 2: 测试构建 (不发布)

1. 访问 GitHub 仓库的 **Actions** 页面
2. 选择 **Build and Release VxKex** 工作流
3. 点击 **Run workflow** 按钮
4. 输入测试版本号,如 `1.1.4.0-test`
5. 点击绿色的 **Run workflow** 按钮

**注意**: 手动触发的构建不会创建 Release,只会生成 Artifacts

---

## 🎨 自定义配置

### 修改安装程序图标

编辑工作流文件 `.github/workflows/build-release.yml`,找到:

```pascal
SetupIconFile=KexGui\icon.ico
```

替换为你的图标文件路径。

### 修改默认安装目录

```pascal
DefaultDirName={autopf}\VxKex
```

修改为:

```pascal
DefaultDirName={autopf}\MyCustomFolder
```

### 禁用 Clash Verge 自动配置

在工作流的 Inno Setup 脚本中,注释掉以下行:

```pascal
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    // Sleep(1000);
    // AutoConfigureClashVerge;  // <- 注释这行
  end;
end;
```

---

## 🔍 验证构建结果

### 检查安装程序完整性

使用 SHA256 校验和验证:

```powershell
# Windows PowerShell
Get-FileHash -Path "VxKex-1.1.3.1428-Setup.exe" -Algorithm SHA256

# 对比下载的 .sha256 文件中的值
Get-Content "VxKex-1.1.3.1428-Setup.exe.sha256"
```

```bash
# Linux/macOS
sha256sum VxKex-1.1.3.1428-Setup.exe
```

### 测试安装程序

在虚拟机或测试环境中运行:

```cmd
# 标准安装 (带界面)
VxKex-1.1.3.1428-Setup.exe

# 静默安装
VxKex-1.1.3.1428-Setup.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART

# 静默卸载
"%ProgramFiles%\VxKex\unins000.exe" /VERYSILENT
```

---

## 📊 了解构建统计

### 查看构建时间

在 Actions 页面的工作流执行记录中可以看到:

- **总构建时间**: 通常 10-15 分钟
- **x86 编译**: 约 3-5 分钟
- **x64 编译**: 约 3-5 分钟
- **Inno Setup 打包**: 约 1-2 分钟

### 查看文件大小

典型的构建产物大小:

- Setup.exe: 约 5-10 MB (取决于压缩率)
- Portable-x86.zip: 约 3-5 MB
- Portable-x64.zip: 约 4-6 MB

---

## ⚠️ 常见错误及解决方案

### 错误 1: "MSBuild not found"

**原因**: GitHub Runner 上的 MSBuild 配置问题

**解决方案**: 工作流已配置 `microsoft/setup-msbuild@v2`,确保该步骤成功执行

### 错误 2: "Permission denied"

**原因**: GitHub Actions 权限不足

**解决方案**:
1. 进入仓库 **Settings** → **Actions** → **General**
2. 在 "Workflow permissions" 中选择 **Read and write permissions**
3. 勾选 **Allow GitHub Actions to create and approve pull requests**

### 错误 3: "Tag already exists"

**原因**: 版本标签重复

**解决方案**:
```bash
# 删除本地标签
git tag -d v1.1.3.1428

# 删除远程标签
git push origin :refs/tags/v1.1.3.1428

# 重新创建
git tag v1.1.4.0
git push origin v1.1.4.0
```

### 错误 4: "ISCC.exe not found"

**原因**: Inno Setup 安装失败

**解决方案**: 检查工作流中的 Inno Setup 安装步骤,可能需要更新下载链接

---

## 🚀 性能优化建议

### 1. 启用缓存加速构建

在工作流中添加 NuGet 缓存:

```yaml
- name: Cache NuGet Packages
  uses: actions/cache@v3
  with:
    path: ~/.nuget/packages
    key: ${{ runner.os }}-nuget-${{ hashFiles('**/*.csproj') }}
    restore-keys: |
      ${{ runner.os }}-nuget-
```

### 2. 并行构建平台

将 x86 和 x64 构建改为并行执行 (需要修改工作流结构)

### 3. 减小安装包体积

在 Inno Setup 脚本中调整压缩设置:

```pascal
Compression=lzma2/ultra64  ; 最大压缩 (慢)
Compression=lzma2/fast     ; 快速压缩 (大)
Compression=lzma2/normal   ; 平衡 (推荐)
```

---

## 📚 下一步

- 📖 阅读 [完整文档](README.md) 了解高级功能
- 🔐 配置 [代码签名](README.md#代码签名-可选) 提升信任度
- 🎨 自定义安装程序界面和安装选项
- 📊 添加构建状态徽章到项目 README

---

## 💡 最佳实践

1. **版本号管理**: 遵循语义化版本 (Semantic Versioning)
2. **提交信息**: 使用清晰的提交信息,如 "feat: 添加新功能" 或 "fix: 修复bug"
3. **测试**: 在正式发布前先手动触发测试构建
4. **文档**: 在 Release 说明中记录更改内容
5. **备份**: 定期备份重要的构建产物

---

## 🤝 获取帮助

如果遇到问题:

1. 查看 [Actions 执行日志](https://github.com/YOUR_REPO/actions)
2. 阅读 [完整文档](README.md)
3. 在 [GitHub Issues](https://github.com/YOUR_REPO/issues) 提问
4. 参考 [Inno Setup 官方文档](https://jrsoftware.org/ishelp/)

---

**祝你构建顺利! 🎉**
