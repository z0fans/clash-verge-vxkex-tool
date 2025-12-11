# Clash Verge VxKex 一键配置工具 v5.0.0

> 🚀 让 Clash Verge Rev 在 Windows 7 上完美运行！单个 EXE 文件，一键配置！

[![版本](https://img.shields.io/badge/版本-v5.0.0-blue.svg)](https://github.com/clash-verge-rev/clash-verge-rev/releases)
[![Windows 7](https://img.shields.io/badge/Windows-7%20SP1%2B-0078d7.svg)](https://www.microsoft.com/windows)
[![许可证](https://img.shields.io/badge/许可证-GPL--3.0-green.svg)](LICENSE)

## 📋 问题背景

Clash Verge Rev v1.6.2+ 在 Windows 7 上启动时会报错 `0xc0000005`，原因是调用了 Windows 8+ 的 API。

**本工具自动安装 VxKex 兼容层并配置注册表，让 Clash Verge 在 Windows 7 上完美运行！**

### 🎉 v5.0.0 重大更新

针对 **Issue #1041** 的完整解决方案:
- ✅ **修复 VxKex 安装不完整问题** - 5 项完整性验证
- ✅ **修复配置后仍无法启动问题** - 使用完整路径配置
- ✅ **详细错误诊断** - 自动生成诊断报告
- ✅ **KB 更新检测** - 检查必需的系统更新

---

## ✨ 功能特性

### 核心功能
- 🎁 **单文件分发** - 仅需一个 EXE 文件，所有资源内嵌
- 📦 **行业标准** - 使用 NSIS 打包工具（业界标准）
- 🚀 **下载即用** - 双击 EXE 文件即可运行
- ✅ **零依赖** - 无需 Python、.NET Framework 4.0+、第三方工具

### v5.0.0 新增特性
- 🔍 **智能验证系统** - 10+ 项完整性检查 (系统要求 + VxKex 安装 + 配置验证)
- 🏥 **KB 更新检测** - 自动检查 KB2533623 和 KB2670838
- 📊 **5 步清晰流程** - 每步详细进度和状态提示
- 🛠️ **自动诊断报告** - 失败时生成详细报告并提供修复建议
- ✅ **完整路径配置** - 修复之前仅用文件名导致的配置失效问题
- 🎨 **美化界面** - Unicode 边框、彩色日志、实时状态更新

### 基础功能
- ✅ **自动安装 VxKex** - 内置 VxKex 安装包（v1.1.2）
- ✅ **自动检测路径** - 自动找到 Clash Verge 安装位置
- ✅ **图形界面** - Windows Forms，简单直观
- ✅ **专为 Windows 7** - 完美兼容 Windows 7 SP1
- 🔧 **自动清理** - 配置完成后自动删除临时文件

---

## 🎯 使用方法

### 📥 下载并运行（3 步搞定）

1. **下载** 从 [Releases](../../releases) 下载 `ClashVerge-VxKex-Configurator.exe`（约 4 MB）
2. **运行** 右键 EXE → 选择"以管理员身份运行"
3. **配置** 在 GUI 中点击"🚀 一键启用 VxKex"，等待 1-2 分钟

完成！现在可以正常启动 Clash Verge 了。

---

## 🔨 开发者

### 从源码构建

```powershell
# 方式 1: 使用 NSIS（推荐）
# 1. 安装 NSIS: choco install nsis -y
# 2. 构建: makensis installer.nsi
# 输出: dist\ClashVerge-VxKex-Configurator.exe

# 方式 2: GitHub Actions 自动构建
# 推送带 v* 标签即可自动触发构建和发布
```

### 直接运行（调试）

```batch
# 方式 1: BAT 启动器
ClashVerge-VxKex-Configurator.bat

# 方式 2: PowerShell 直接运行
powershell -ExecutionPolicy Bypass -File .\VxKexConfigurator.ps1
```

详见 [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)

---

## 🔧 工具原理

### VxKex 是什么？

[VxKex](https://github.com/i486/VxKex) 是 Windows 7 API 扩展层，可以让调用 Windows 8/10/11 API 的程序在 Windows 7 上运行。

### 本工具做了什么？

1. **自动安装 VxKex** - 静默安装内置的 VxKex
2. **配置注册表** - 为 Clash Verge 配置 VxKex 兼容性设置
3. **设置兼容标志** - 应用 Windows 7 兼容模式

---

---

## 📂 项目结构

```
vxkex-configurator/
├── ClashVerge-VxKex-Configurator.bat    # 主配置工具 BAT 启动器
├── VxKexConfigurator.ps1                # PowerShell GUI 主程序
├── VxKex-Diagnostic.bat                 # 🆕 VxKex 安装诊断工具
├── VxKex-Diagnostic.ps1                 # 🆕 诊断工具 PowerShell 脚本
├── VxKex-Manual-Install.bat             # 🆕 VxKex 手动安装工具
├── VxKex-Manual-Install.ps1             # 🆕 手动安装 PowerShell 脚本
├── installer.nsi                        # NSIS 安装脚本
├── BUILD_INSTRUCTIONS.md                # 详细构建文档
├── QUICK_START.md                       # 快速使用指南
├── TROUBLESHOOTING.md                   # 🆕 故障排除指南
├── README.md                            # 本文档
├── .github/workflows/
│   └── build-nsis.yml                   # GitHub Actions 工作流
├── resources/
│   └── KexSetup_Release_*.exe          # VxKex 安装包（3.9 MB）
└── dist/
    └── *.exe                            # 构建输出（Git 忽略）
```

### 🆕 新增工具说明

| 工具 | 用途 | 使用场景 |
|------|------|----------|
| **VxKex-Diagnostic.bat** | 诊断 VxKex 安装状态 | 验证 VxKex 是否正确安装 |
| **VxKex-Manual-Install.bat** | 手动安装 VxKex | 静默安装失败时使用 |
| **TROUBLESHOOTING.md** | 故障排除指南 | 遇到问题时查阅 |

---

## ❓ 常见问题

### Q: 软件安装成功，但不确定 VxKex 是否正确安装？

**A:** VxKex 使用**静默安装**模式，没有可见的安装界面。请使用以下方法验证：

**方法 1: 运行诊断工具（推荐）**
```batch
双击运行: VxKex-Diagnostic.bat
```
诊断工具会检查：
- ✅ VxKex 安装目录是否存在
- ✅ VxKex 注册表项是否正确
- ✅ Clash Verge 配置是否完成
- ✅ VxKexLoader.dll 是否存在

**方法 2: 手动检查**
1. 查看 `C:\Program Files\VxKex` 目录是否存在
2. 查看 `C:\Windows\System32\VxKexLoader.dll` 文件是否存在

如果诊断失败，请查看 [TROUBLESHOOTING.md](TROUBLESHOOTING.md) 获取详细的故障排除指南。

### Q: 静默安装失败，怎么手动安装 VxKex？

**A:** 使用手动安装工具：
```batch
双击运行: VxKex-Manual-Install.bat
```
选择 **图形界面安装**（选项 1），您将看到完整的安装过程。

安装完成后，再运行 `ClashVerge-VxKex-Configurator.bat` 配置 Clash Verge。

### Q: 安装时出现红色错误窗口怎么办？

**A:** 请升级到 **v5.0.0** 最新版本。v5.0.0 包含完整的错误诊断和自动修复机制。详见 [CHANGELOG.md](CHANGELOG.md) v5.0.0 部分

### Q: v5.0.0 相比之前版本有什么改进？

**A:** v5.0.0 是重大更新版本，完整解决了 Issue #1041 中的所有问题:
- ✅ **10+ 项完整性验证** - 确保每步都正确执行
- ✅ **KB 更新检测** - 自动检查必需的系统更新
- ✅ **完整路径配置** - 修复之前仅用文件名的 Bug
- ✅ **自动诊断报告** - 失败时生成详细报告
- ✅ **预期成功率 90%+** - 大幅提升可靠性

**强烈建议所有用户升级到 v5.0.0！**

### Q: 为什么需要管理员权限？

**A:** 因为需要：
1. 安装 VxKex 到系统目录
2. 修改系统注册表

### Q: 会修改 Clash Verge 程序吗？

**A:** 不会！本工具只修改 Windows 注册表，不修改任何程序文件。

### Q: 支持哪些 Windows 版本？

**A:**
- ✅ **Windows 7 SP1**（主要目标，专门优化）
- ✅ Windows 8/8.1/10/11（也支持，但这些版本通常不需要 VxKex）

### Q: 为什么使用 NSIS？

**A:** NSIS 是业界标准的 Windows 安装包工具，具有：
- ✅ 成熟稳定，广泛应用于各类软件
- ✅ 完善的 GitHub Actions 支持
- ✅ 完美兼容 Windows 7 SP1+

### Q: 杀毒软件报毒？

**A:** 误报。使用 NSIS 开源工具打包，代码开源可审查

---

## 📜 许可证

本工具采用 **GPL-3.0** 许可证，与 Clash Verge Rev 和 VxKex 保持一致。

**包含组件：**
- VxKex v1.1.2 - [GPL-3.0](https://github.com/i486/VxKex)
- Clash Verge Rev - [GPL-3.0](https://github.com/clash-verge-rev/clash-verge-rev)

---

## 🔗 相关链接

- [Issue #1041](https://github.com/clash-verge-rev/clash-verge-rev/issues/1041) - 原始问题讨论
- [VxKex 项目](https://github.com/i486/VxKex) - Windows 7 API 扩展
- [Clash Verge Rev](https://github.com/clash-verge-rev/clash-verge-rev) - 主项目

---

## 🙏 致谢

- [VxKex](https://github.com/i486/VxKex) 项目提供 Windows 7 兼容层
- [Clash Verge Rev](https://github.com/clash-verge-rev/clash-verge-rev) 社区
- 所有在 Issue #1041 中提供反馈的用户

---

**Made with ❤️ for Clash Verge Rev Community**

如有问题或建议，请在 [GitHub Issues](https://github.com/clash-verge-rev/clash-verge-rev/issues) 中反馈。
