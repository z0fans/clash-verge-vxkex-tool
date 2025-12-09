# Clash Verge VxKex 一键配置工具 (PowerShell 版)

> 🚀 让 Clash Verge Rev 在 Windows 7 上一键启动！原生 PowerShell 实现，无需 Python！

## 📋 问题背景

Clash Verge Rev v1.6.2+ 版本在 Windows 7 上启动时会报错 `0xc0000005`（应用程序错误），原因是程序调用了 Windows 8+ 才有的 API 函数。

**现在只需要一键！**

---

## ✨ 功能特性

- ✅ **PowerShell 原生实现** - 无需 Python 运行时
- ✅ **一键完成** - 无需任何手动操作
- ✅ **自动安装 VxKex** - 内置 VxKex 安装包（v1.1.2）
- ✅ **自动检测路径** - 自动找到 Clash Verge 安装位置
- ✅ **图形界面** - Windows Forms，简单直观
- ✅ **体积小** - 仅依赖 Windows 内置组件
- ✅ **启动快** - 原生技术栈，无 DLL 兼容性问题

---

## 🎯 使用方法

### 下载预编译版本（推荐）

1. 从 [Releases](../../releases) 下载 `ClashVerge-VxKex-Configurator-v1.0-PowerShell.zip`
2. 解压到任意目录
3. **右键 `ClashVerge-VxKex-Configurator.exe` → 以管理员身份运行**
4. 选择 Clash Verge 可执行文件（或自动检测）
5. 点击 **"🚀 一键启用 VxKex"** 按钮
6. 等待完成（约 1-2 分钟）
7. ✅ 完成！现在可以启动 Clash Verge 了

⚠️ **注意**: 必须保持 `resources` 文件夹与 `.exe` 在同一目录！

### 从源码运行

直接运行 PowerShell 脚本:

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

```powershell
# 1. 安装 ps2exe
Install-Module -Name ps2exe -Scope CurrentUser -Force

# 2. 运行构建脚本
.\build-powershell.ps1
```

### 构建产物

- 位置：`dist/ClashVerge-VxKex-Configurator.exe`
- 大小：约 200 KB + VxKex 安装包 (3.9 MB)
- 特点：原生 PowerShell，无需额外运行时

---

## 📂 目录结构

```
vxkex-configurator/
├── VxKexConfigurator.ps1                      # 主程序（PowerShell + Windows Forms）
├── build-powershell.ps1                       # 构建脚本
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
