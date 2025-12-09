# Clash Verge VxKex 一键配置工具 (PowerShell 版)

> 🚀 让 Clash Verge Rev 在 Windows 7 上一键启动！原生 PowerShell 实现，无需 Python！

## 📋 问题背景

Clash Verge Rev v1.6.2+ 版本在 Windows 7 上启动时会报错 `0xc0000005`（应用程序错误），原因是程序调用了 Windows 8+ 才有的 API 函数。

**现在只需要一键！**

---

## ✨ 功能特性

- 🎁 **单文件 EXE** - 一个文件包含所有内容
- 🚀 **下载即用** - 无需解压，直接运行
- ✅ **零依赖** - 无需 Python、.NET Framework 4.0+
- ✅ **一键完成** - 无需任何手动操作
- ✅ **自动安装 VxKex** - 内置 VxKex 安装包（v1.1.2）
- ✅ **自动检测路径** - 自动找到 Clash Verge 安装位置
- ✅ **图形界面** - Windows Forms，简单直观
- ✅ **完美兼容** - Windows 7 SP1+ 原生支持

---

## 🎯 使用方法

### 下载预编译版本（推荐）

**超级简单！只需 3 步：**

1. 从 [Releases](../../releases) 下载 `ClashVerge-VxKex-Configurator.exe`
2. **右键 → 以管理员身份运行**
3. ✅ 完成！按照 GUI 提示操作即可

**工作流程：**
- 自动解压文件到临时目录
- 启动 GUI 配置界面
- 选择 Clash Verge 路径（或自动检测）
- 点击"🚀 一键启用 VxKex"
- 等待完成（约 1-2 分钟）
- 配置完成后自动清理临时文件

### 从源码运行

方式 1: 使用 BAT 启动器（推荐）

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

- Windows 系统
- PowerShell 2.0+ (Windows 7+ 内置)
- ps2exe 模块

### 打包步骤

无需打包!直接分发以下文件:

- `ClashVerge-VxKex-Configurator.bat` - 启动器
- `VxKexConfigurator.ps1` - PowerShell 脚本
- `resources/` - 资源文件夹

### 文件说明

- 总大小：约 4 MB (主要是 VxKex 安装包)
- 特点：纯脚本,无需编译,无需 .NET Framework

---

## 📂 目录结构

```
vxkex-configurator/
├── ClashVerge-VxKex-Configurator.bat          # 启动器 (检查权限并调用 PS1)
├── VxKexConfigurator.ps1                      # 主程序（PowerShell + Windows Forms）
├── README.md                                  # 本文档
└── resources/
    └── KexSetup_Release_1_1_2_1428.exe       # VxKex 安装包（3.9 MB）
```

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
- ✅ Windows 7 SP1（主要目标）
- ✅ Windows 8/8.1
- ✅ Windows 10/11（虽然不需要，但也能用）

### Q: 为什么选择 PowerShell 而不是 Python？

**A:**
- ✅ Windows 7+ 原生支持 PowerShell
- ✅ 无需安装 Python 运行时
- ✅ 没有 DLL 兼容性问题
- ✅ 体积更小，启动更快
- ✅ 更稳定可靠

### Q: 为什么不用 ps2exe 打包成 EXE？

**A:**
- ps2exe 打包的 EXE 需要 .NET Framework 4.0+
- Windows 7 默认只有 .NET Framework 3.5
- 用户需要额外安装 .NET Framework
- 直接运行 PowerShell 脚本更简单，无需任何依赖！

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
