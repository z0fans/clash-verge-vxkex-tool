# Clash Verge VxKex 一键配置工具

> 🚀 让 Clash Verge Rev 在 Windows 7 上一键启动！Windows 原生打包，单个 EXE 文件！

## 📋 问题背景

Clash Verge Rev v1.6.2+ 版本在 Windows 7 上启动时会报错 `0xc0000005`（应用程序错误），原因是程序调用了 Windows 8+ 才有的 API 函数。

**现在只需要一个 EXE 文件，双击即可！**

---

## ✨ 功能特性

- 🎁 **单文件分发** - 仅需一个 EXE 文件，所有资源内嵌
- 📦 **Windows 原生** - 使用 Windows 自带的 IExpress 打包
- 🚀 **下载即用** - 双击 EXE 文件即可运行
- ✅ **零依赖** - 无需 Python、.NET Framework 4.0+、第三方工具
- ✅ **一键完成** - 无需任何手动操作
- ✅ **自动安装 VxKex** - 内置 VxKex 安装包（v1.1.2）
- ✅ **自动检测路径** - 自动找到 Clash Verge 安装位置
- ✅ **图形界面** - Windows Forms，简单直观
- ✅ **专为 Windows 7** - 完美兼容 Windows 7 SP1
- 🔧 **自动清理** - 配置完成后自动删除临时文件

---

## 🎯 使用方法

### 下载预编译版本（推荐）

**超级简单！只需 3 步：**

1. 从 [Releases](../../releases) 下载文件：
   - `ClashVerge-VxKex-Configurator.exe`（约 4-5 MB）
2. **右键点击 EXE → 选择"以管理员身份运行"**
3. ✅ 完成！按照 GUI 提示操作即可

**工作流程：**
- 自动解压文件到临时目录
- 启动 GUI 配置界面
- 自动检测或手动选择 Clash Verge 路径
- 点击"🚀 一键启用 VxKex"
- 等待配置完成（约 1-2 分钟）
- 配置完成后自动清理临时文件

### 从源码构建

如果需要自己构建 EXE 文件：

```powershell
# 1. 打开 PowerShell
cd tools\vxkex-configurator

# 2. 执行构建脚本（Windows 原生 IExpress 打包）
.\build-win7-native.ps1

# 3. 输出文件位于: dist\ClashVerge-VxKex-Configurator.exe
```

详细构建说明请参阅 [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)

### 从源码直接运行（开发调试）

方式 1: 使用 BAT 启动器

```batch
ClashVerge-VxKex-Configurator.bat
```

方式 2: 直接运行 PowerShell 脚本

```powershell
powershell -ExecutionPolicy Bypass -File .\VxKexConfigurator.ps1
```

---

## 🔧 工具原理

### VxKex 是什么？

[VxKex](https://github.com/i486/VxKex) 是 Windows 7 API 扩展层，可以让调用 Windows 8/10/11 API 的程序在 Windows 7 上运行。

### 本工具做了什么？

1. **自动安装 VxKex** - 静默安装内置的 VxKex
2. **配置注册表** - 为 Clash Verge 配置 VxKex 兼容性设置
3. **设置兼容标志** - 应用 Windows 7 兼容模式

---

## 🏗️ 构建指南

### 环境要求

**构建环境：**
- Windows 7 SP1 / Windows 8+ / Windows 10 / Windows 11
- PowerShell 2.0+ (Windows 7+ 内置)
- IExpress (Windows 自带工具，无需安装)

**目标运行环境：**
- Windows 7 SP1（主要目标）
- 管理员权限

### 打包步骤

使用 Windows 原生 IExpress 打包：

```powershell
# 标准构建
.\build-win7-native.ps1

# 清理重新构建
.\build-win7-native.ps1 -Clean
```

这将生成：
- `dist/ClashVerge-VxKex-Configurator.exe` - 单个自解压 EXE（约 4-5 MB）

### 打包技术说明

- **打包工具**: Windows 自带的 IExpress
- **打包格式**: CAB 压缩自解压包
- **总大小**: 约 4-5 MB（包含 VxKex 安装包）
- **特点**: 无需第三方工具，Windows 原生支持
- **分发**: 只需分发一个 EXE 文件

详细构建说明请参阅 [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)

---

## 📂 目录结构

```
vxkex-configurator/
├── ClashVerge-VxKex-Configurator.bat          # BAT 启动器（检查权限并调用 PS1）
├── VxKexConfigurator.ps1                      # 主程序（PowerShell + Windows Forms GUI）
├── build-win7-native.ps1                      # Windows 原生 IExpress 打包脚本 ⭐
├── build-iexpress.sed                         # IExpress 配置模板
├── build-embedded.ps1                         # 旧：内嵌式打包脚本（已弃用）
├── build-sfx.ps1                              # 旧：7-Zip SFX 打包脚本（已弃用）
├── BUILD_INSTRUCTIONS.md                      # 详细构建说明文档 ⭐
├── README.md                                  # 本文档
├── resources/
│   └── KexSetup_Release_1_1_2_1428.exe       # VxKex 安装包（3.9 MB）
└── dist/                                      # 构建输出目录
    └── ClashVerge-VxKex-Configurator.exe     # 打包后的单个 EXE 文件 ⭐
```

⭐ = 推荐使用的新方案

---

## ❓ 常见问题

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

### Q: 为什么使用 IExpress 而不是其他打包工具？

**A:** IExpress 是最适合 Windows 7 的打包方案：

**IExpress 优势：**
- ✅ **Windows 原生** - 所有 Windows 版本自带，包括 Windows 7
- ✅ **零依赖** - 无需安装任何第三方工具
- ✅ **稳定可靠** - Microsoft 官方工具，经过充分测试
- ✅ **完美兼容** - 生成的 EXE 在 Windows 7 上完美运行
- ✅ **CI/CD 友好** - 可以在 GitHub Actions 上自动化构建

**其他方案的问题：**
- ❌ **ps2exe**: 需要 .NET Framework 4.0+（Windows 7 默认只有 3.5）
- ❌ **7-Zip SFX**: 需要安装 7-Zip，增加构建复杂度
- ❌ **Base64 内嵌**: 文件体积增大 33%，解压速度慢

### Q: 为什么选择 PowerShell 而不是 Python？

**A:**
- ✅ Windows 7 原生支持 PowerShell 2.0
- ✅ 无需安装 Python 运行时（Python 在 Windows 7 上可能有兼容性问题）
- ✅ Windows Forms 支持完美（基于 .NET 2.0）
- ✅ 体积更小，启动更快
- ✅ 更适合 Windows 系统管理任务

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
