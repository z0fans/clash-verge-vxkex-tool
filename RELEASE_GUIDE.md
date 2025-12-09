# 发布指南

## 📋 发布流程

### 1️⃣ 验证构建

首先访问 GitHub Actions 查看构建状态：
```
https://github.com/z0fans/clash-verge-vxkex-tool/actions
```

✅ 确认 "Build Windows Executable" 工作流成功完成

### 2️⃣ 下载并测试

1. 在 Actions 页面找到最新的成功构建
2. 下载 `ClashVerge-VxKex-Configurator` Artifact
3. 解压得到 `ClashVerge-VxKex-Configurator.exe`
4. 在 Windows 7/10 测试机上运行测试

**测试清单：**
- [ ] 以管理员身份运行成功
- [ ] GUI 界面正常显示
- [ ] 能检测到 VxKex 状态
- [ ] 能检测到 Clash Verge 安装路径
- [ ] 一键配置功能正常
- [ ] 配置完成后 Clash Verge 能正常运行

### 3️⃣ 创建 Release（本地）

当测试通过后，在本地创建标签：

```bash
cd /Users/yuu/Downloads/clash-verge-rev-2.2.3/tools/vxkex-configurator

# 创建标签
git tag -a v1.0.0 -m "Release v1.0.0 - Clash Verge VxKex 一键配置工具

功能：
- 图形界面操作
- 自动安装 VxKex
- 自动检测安装路径
- 一键配置 4 个 exe
- 完整的文档支持

支持系统：
- Windows 7 SP1 或更高版本

相关链接：
- Issue: https://github.com/clash-verge-rev/clash-verge-rev/issues/1041
- VxKex: https://github.com/i486/VxKex
"

# 推送标签
git push origin v1.0.0
```

### 4️⃣ 自动创建 Release

推送标签后，GitHub Actions 会自动：

1. ✅ 构建 Windows exe
2. ✅ 创建 GitHub Release (v1.0.0)
3. ✅ 上传 exe 到 Release
4. ✅ 添加 Release 说明

等待 3-5 分钟后，访问：
```
https://github.com/z0fans/clash-verge-vxkex-tool/releases
```

### 5️⃣ 完善 Release 说明（可选）

如果需要，可以手动编辑 Release 添加更多信息：

- 📸 添加截图
- 📝 添加使用说明
- ⚠️ 添加注意事项
- 🔗 添加相关链接

---

## 🔄 更新版本

当需要发布新版本时：

### 1. 修改代码

```bash
cd /Users/yuu/Downloads/clash-verge-rev-2.2.3/tools/vxkex-configurator

# 修改代码...
git add -A
git commit -m "fix: 修复某个问题"
git push
```

### 2. 创建新标签

```bash
# 例如发布 v1.0.1
git tag -a v1.0.1 -m "Release v1.0.1

修复：
- 修复了某个问题
- 优化了某个功能
"

git push origin v1.0.1
```

### 3. 自动构建

GitHub Actions 会自动构建并发布新版本。

---

## 🏷️ 版本号规范

使用语义化版本 (Semantic Versioning)：

- **v1.0.0** - 主版本（重大更新）
- **v1.1.0** - 次版本（新功能）
- **v1.0.1** - 修订版本（Bug 修复）

**示例：**
- `v1.0.0` - 首次发布
- `v1.0.1` - 修复小问题
- `v1.1.0` - 添加新功能（如卸载功能）
- `v2.0.0` - 重大重构

---

## 📢 发布公告

### 在 Clash Verge Rev 主仓库公告

发布后，可以在 [Issue #1041](https://github.com/clash-verge-rev/clash-verge-rev/issues/1041) 中回复：

```markdown
## ✅ Windows 7 一键配置工具已发布！

为了解决 Windows 7 上的 0xc0000005 错误，我们开发了一键配置工具。

### 下载地址
https://github.com/z0fans/clash-verge-vxkex-tool/releases

### 使用方法
1. 下载 `ClashVerge-VxKex-Configurator.exe`
2. 右键 → 以管理员身份运行
3. 点击"一键启用 VxKex"
4. 完成！

### 功能特性
- ✅ 自动安装 VxKex
- ✅ 自动检测路径
- ✅ 一键完成配置
- ✅ 图形界面操作

欢迎测试反馈！
```

---

## 🐛 处理问题反馈

### 收集反馈

在以下位置收集用户反馈：
- GitHub Issues
- Pull Requests
- 原 Issue #1041 的评论

### 修复流程

1. 在 Issues 中创建问题跟踪
2. 修复代码并测试
3. 提交并推送代码
4. 发布新版本
5. 关闭相关 Issue

---

## 📊 发布检查清单

在发布前确认：

- [ ] 代码已测试
- [ ] 文档已更新
- [ ] README 版本号已更新
- [ ] CHANGELOG 已记录
- [ ] GitHub Actions 构建成功
- [ ] 在 Windows 7 上测试通过
- [ ] 在 Windows 10 上测试通过
- [ ] exe 文件大小合理（8-10 MB）
- [ ] 无已知严重 Bug

---

## 🔗 相关链接

- **仓库首页**: https://github.com/z0fans/clash-verge-vxkex-tool
- **Actions 构建**: https://github.com/z0fans/clash-verge-vxkex-tool/actions
- **Releases 页面**: https://github.com/z0fans/clash-verge-vxkex-tool/releases
- **Issues 页面**: https://github.com/z0fans/clash-verge-vxkex-tool/issues
- **原始 Issue**: https://github.com/clash-verge-rev/clash-verge-rev/issues/1041

---

## 💡 快速命令参考

```bash
# 查看当前标签
git tag

# 删除本地标签
git tag -d v1.0.0

# 删除远程标签
git push origin :refs/tags/v1.0.0

# 查看标签详情
git show v1.0.0

# 推送所有标签
git push origin --tags
```
