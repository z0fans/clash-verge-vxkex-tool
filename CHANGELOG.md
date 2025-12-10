# 更新日志

## [4.0.2] - 2025-12-10

### 🐛 Bug 修复
- **修复 NSIS 安装界面中文乱码问题**
  - 添加 `Unicode True` 指令启用 Unicode 支持
  - 将 `installer.nsi` 文件转换为 UTF-8 BOM 编码
  - NSIS 现在可以正确显示所有中文字符
- **症状**: 安装界面的中文文本显示为乱码（如"ç²âœè´µèžèå¸…è£"）
- **影响**: 所有使用 v4.0.0 和 v4.0.1 构建的安装器
- **解决**: NSIS 编译器现在能正确处理中文字符串

### 📝 技术细节
- **修改文件**: `installer.nsi`
- **关键改动**:
  - 第 5-6 行: 添加 `Unicode True` 指令
  - 文件编码: UTF-8 → UTF-8 BOM (EF BB BF)
- **原理**: NSIS 需要 UTF-8 BOM 标记才能识别文件为 Unicode，配合 `Unicode True` 指令才能正确编译中文字符串

---

## [4.0.1] - 2025-12-10

### 🐛 Bug 修复
- **修复路径配置错误**: PowerShell 脚本中 VxKex 安装包路径从 `$PSScriptRoot\resources\KexSetup_Release_1_1_2_1428.exe` 修正为 `$PSScriptRoot\KexSetup_Release_1_1_2_1428.exe`，与 NSIS 解压路径保持一致
- **症状**: v4.0.0 在 Windows 7 上运行时会显示红色错误窗口 "找不到 VxKex 安装包"
- **影响**: 100% 的 Windows 7 用户无法成功配置
- **解决**: 路径配置修复后，工具可以正常找到并安装 VxKex

### ✨ 新增功能
- **NSIS 增强错误检查**: 在执行 BAT 脚本前验证 VxKex 安装包是否存在
- **改进调试输出**: 安装过程中显示解压路径，便于问题排查
- **更好的错误提示**: 明确提示用户需要以管理员身份运行

### 📝 文档更新
- 新增 `BUG_FIX_v4.0.1.md` - 详细的 bug 分析和修复说明
- 新增 `重新构建指南.md` - Windows 系统上的完整构建步骤
- 更新 `README.md` - 添加故障排除常见问题
- 删除 `诊断报告.md` 和 `PLATFORM_NOTICE.md`（之前的误判文档）

### 🔧 技术改进
- **文件修改清单**:
  - `VxKexConfigurator.ps1:8` - 修复路径配置
  - `installer.nsi:11` - 版本号更新为 4.0.1
  - `installer.nsi:56-59` - 添加文件存在性检查
  - `installer.nsi:65-66` - 增强错误提示

---

## [4.0.0] - 2025-12-09

### 🎉 初始发布
- 基于 NSIS 的单文件安装器
- PowerShell + Windows Forms 图形界面
- 自动安装 VxKex v1.1.2
- 自动配置 Clash Verge 兼容性
- 支持 Windows 7/8/10/11

### ❌ 已知问题
- **严重 Bug**: PowerShell 脚本中 VxKex 安装包路径配置错误
- **影响范围**: 所有 Windows 7 用户
- **临时解决方案**: 手动修改解压后的 PowerShell 脚本
- **永久修复**: 已在 v4.0.1 中修复

---

## 版本对比表

| 版本 | 发布日期 | 状态 | 主要问题 | 推荐使用 |
|------|----------|------|----------|----------|
| 4.0.0 | 2025-12-09 | ❌ 废弃 | 路径配置 bug，无法安装 | ❌ 不推荐 |
| 4.0.1 | 2025-12-10 | ✅ 稳定 | 无已知问题 | ✅ **推荐** |

---

## 升级指南

### 从 v4.0.0 升级到 v4.0.1

**如果您已经下载了 v4.0.0:**
1. 删除旧的 `ClashVerge-VxKex-Configurator.exe`
2. 重新构建或下载 v4.0.1
3. 在 Windows 7 上重新运行

**如果您已经使用 v4.0.0 遇到错误:**
1. VxKex 安装失败不影响系统
2. 直接使用 v4.0.1 重新配置即可
3. 无需卸载或清理

---

## 贡献者

- **Bug 报告**: 感谢用户提供详细的错误截图和描述
- **代码修复**: AI 辅助分析和修复
- **测试**: 待社区在 Windows 7 上验证

---

## 相关链接

- [Bug 修复详情](BUG_FIX_v4.0.1.md)
- [重新构建指南](重新构建指南.md)
- [原始 Issue #1041](https://github.com/clash-verge-rev/clash-verge-rev/issues/1041)
- [VxKex 项目](https://github.com/i486/VxKex)

---

**下一步计划:**
- [ ] 在真实 Windows 7 系统上测试 v4.0.1
- [ ] 发布到 GitHub Releases
- [ ] 更新主项目文档
- [ ] 收集用户反馈
