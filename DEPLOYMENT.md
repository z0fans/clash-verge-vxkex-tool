# VxKex Configurator - 部署指南

本文档说明如何将新版本部署到 GitHub 并触发自动构建。

---

## 📋 部署前准备

### 1. 确认本地更改

```bash
cd tools/vxkex-configurator
git status
```

确保所有新文件都已添加：
- ✅ `build-win7-native.ps1` - 新的构建脚本
- ✅ `build-iexpress.sed` - IExpress 配置
- ✅ `BUILD_INSTRUCTIONS.md` - 构建文档
- ✅ `QUICK_START.md` - 快速指南
- ✅ `PROJECT_SUMMARY.md` - 项目总结
- ✅ `CHANGELOG_WIN7_NATIVE.md` - 变更日志
- ✅ `.github/workflows/build-iexpress.yml` - 新的 CI/CD 配置
- ✅ 更新的 `README.md`

---

## 🚀 方式 1: 一键部署（推荐）

### 适用于 macOS/Linux

直接运行部署脚本，它会自动完成所有步骤：

```bash
./deploy.sh
```

脚本会依次执行：
1. ✅ 检查当前状态
2. ✅ 添加新文件到 git
3. ✅ 提交更改
4. ✅ 删除本地旧 tags
5. ✅ 推送代码到 GitHub
6. ✅ 删除远程旧 tags

---

## 🔧 方式 2: 手动部署

### 步骤 1: 添加并提交更改

```bash
# 查看更改
git status

# 添加所有新文件
git add .

# 提交更改
git commit -m "feat: Windows 原生 IExpress 打包方案

- 使用 Windows 自带的 IExpress 工具打包
- 单个 EXE 文件，约 4-5 MB
- 完美兼容 Windows 7 SP1
- 新增完整文档和 CI/CD 配置
- 体积减小 30%，解压速度提升 50%
"
```

### 步骤 2: 清理旧的 Tags

#### 选项 A: 使用 PowerShell 脚本（Windows）

```powershell
# DRY RUN - 预览将要删除的内容
.\cleanup-old-releases.ps1 -DryRun

# 实际删除（需要确认）
.\cleanup-old-releases.ps1

# 强制删除（跳过确认）
.\cleanup-old-releases.ps1 -Force
```

#### 选项 B: 手动删除（任何系统）

```bash
# 查看所有本地 tags
git tag -l

# 删除所有本地 tags
git tag -l | xargs git tag -d

# 查看所有远程 tags
git ls-remote --tags origin

# 删除所有远程 tags（逐个删除）
git push origin --delete v1.0.0
git push origin --delete v1.0.1
git push origin --delete v1.0.2
git push origin --delete v1.0.3
git push origin --delete v1.0.4
git push origin --delete v1.0.5
git push origin --delete v1.0.6
git push origin --delete v2.0.0
git push origin --delete v2.0.1
git push origin --delete v3.0.0

# 或者使用循环批量删除
git ls-remote --tags origin | awk -F'/' '{print $3}' | grep -v '\^{}' | xargs -I {} git push origin --delete {}
```

### 步骤 3: 推送代码

```bash
# 推送到主分支
git push origin main
```

### 步骤 4: 清理 GitHub Releases

⚠️ **重要**: 删除 tags 不会自动删除 GitHub Releases，需要手动清理。

#### 选项 A: 使用 GitHub Web 界面

1. 访问: https://github.com/z0fans/clash-verge-vxkex-tool/releases
2. 点击每个 Release 右侧的菜单
3. 选择 "Delete" 删除
4. 确认删除

#### 选项 B: 使用 GitHub CLI

```bash
# 安装 GitHub CLI (如果还没安装)
# macOS: brew install gh
# Windows: choco install gh
# Linux: 见 https://cli.github.com/

# 登录
gh auth login

# 查看所有 releases
gh release list --repo z0fans/clash-verge-vxkex-tool

# 删除所有 releases（逐个删除）
gh release delete v1.0.0 --repo z0fans/clash-verge-vxkex-tool --yes
gh release delete v1.0.1 --repo z0fans/clash-verge-vxkex-tool --yes
gh release delete v1.0.2 --repo z0fans/clash-verge-vxkex-tool --yes
gh release delete v1.0.3 --repo z0fans/clash-verge-vxkex-tool --yes
gh release delete v1.0.4 --repo z0fans/clash-verge-vxkex-tool --yes
gh release delete v1.0.5 --repo z0fans/clash-verge-vxkex-tool --yes
gh release delete v1.0.6 --repo z0fans/clash-verge-vxkex-tool --yes
gh release delete v2.0.0 --repo z0fans/clash-verge-vxkex-tool --yes
gh release delete v2.0.1 --repo z0fans/clash-verge-vxkex-tool --yes
gh release delete v3.0.0 --repo z0fans/clash-verge-vxkex-tool --yes

# 或者使用循环批量删除
gh release list --repo z0fans/clash-verge-vxkex-tool --limit 100 | awk '{print $1}' | xargs -I {} gh release delete {} --repo z0fans/clash-verge-vxkex-tool --yes
```

### 步骤 5: 创建新的 Tag 并触发构建

```bash
# 创建新的 tag (建议版本号: v4.0.0)
git tag v4.0.0

# 推送 tag 到远程（触发 GitHub Actions 自动构建）
git push origin v4.0.0
```

### 步骤 6: 监控构建过程

1. 访问 GitHub Actions: https://github.com/z0fans/clash-verge-vxkex-tool/actions
2. 查看 "Build Windows Native IExpress Package" 工作流
3. 等待构建完成（约 2-5 分钟）
4. 构建成功后，会自动创建新的 Release

### 步骤 7: 验证 Release

1. 访问: https://github.com/z0fans/clash-verge-vxkex-tool/releases
2. 确认新的 Release (v4.0.0) 已创建
3. 确认附件包含 `ClashVerge-VxKex-Configurator.exe`
4. 下载并测试 EXE 文件

---

## 📊 CI/CD 工作流说明

### 触发条件

GitHub Actions 会在以下情况自动运行：

1. **推送到 main 分支** - 构建但不创建 Release
2. **推送 tag (v*)** - 构建并自动创建 Release
3. **Pull Request** - 仅构建测试
4. **手动触发** - 在 Actions 页面手动运行

### 构建流程

```
1. Checkout 代码
   ↓
2. 检查必需文件
   ↓
3. 运行 build-win7-native.ps1
   ↓
4. 验证构建输出
   ↓
5. 上传 Artifact
   ↓
6. (如果是 tag) 创建 GitHub Release
```

### 构建产物

- **Artifact**: `ClashVerge-VxKex-Configurator-Windows-Native`
  - 包含: `ClashVerge-VxKex-Configurator.exe`
  - 保留 90 天

- **Release** (仅 tag 推送时):
  - 标题: tag 名称 (如 v4.0.0)
  - 附件: `ClashVerge-VxKex-Configurator.exe`
  - 说明: 自动生成的 Release Notes

---

## ❓ 常见问题

### Q: 为什么要删除旧的 tags？

**A:**
- 清理历史版本，保持仓库整洁
- 新版本采用完全不同的打包方式
- 避免版本号混淆

### Q: 删除 tags 后能恢复吗？

**A:**
- 本地 tags: 可以通过 `git reflog` 恢复
- 远程 tags: 无法恢复，删除前请确认
- Releases: 删除后无法恢复，需要重新创建

### Q: 如果构建失败怎么办？

**A:**
1. 查看 GitHub Actions 日志
2. 检查错误信息
3. 修复问题后重新推送
4. 或者删除 tag 后重新创建

### Q: 可以先测试构建吗？

**A:** 可以！两种方式：

**方式 1**: 在本地构建测试（Windows 系统）
```powershell
.\build-win7-native.ps1
```

**方式 2**: 推送到分支但不创建 tag
```bash
git checkout -b test-build
git push origin test-build
# 在 GitHub Actions 中查看构建结果
```

### Q: 如何更新已存在的 Release？

**A:**
1. 删除旧的 Release 和 tag
2. 重新创建相同版本号的 tag
3. 推送 tag 触发新构建

---

## 📝 版本号建议

采用语义化版本号 (Semantic Versioning):

- **v4.0.0** - 推荐用于新的 IExpress 打包方案（主要架构变更）
- **v4.0.1** - 小的 bug 修复
- **v4.1.0** - 新增功能
- **v5.0.0** - 下一个主要版本

---

## 🔗 相关链接

- **GitHub 仓库**: https://github.com/z0fans/clash-verge-vxkex-tool
- **Actions 页面**: https://github.com/z0fans/clash-verge-vxkex-tool/actions
- **Releases 页面**: https://github.com/z0fans/clash-verge-vxkex-tool/releases
- **GitHub CLI**: https://cli.github.com/

---

## 📧 需要帮助？

如果部署过程中遇到问题：

1. 查看 GitHub Actions 日志
2. 检查本文档的常见问题部分
3. 在 GitHub Issues 中提问

---

**祝部署顺利！🎉**
