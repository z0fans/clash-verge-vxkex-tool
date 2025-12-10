# Clash Verge VxKex 一键配置工具

> 🚀 让 Clash Verge Rev 在 Windows 7 上完美运行！单个 EXE 文件，一键配置！

## 📋 问题背景

Clash Verge Rev v1.6.2+ 在 Windows 7 上启动时会报错 `0xc0000005`，原因是调用了 Windows 8+ 的 API。

**本工具自动安装 VxKex 兼容层并配置注册表，让 Clash Verge 在 Windows 7 上完美运行！**

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

### 📥 下载并运行（3 步搞定）

1. **下载** 从 [Releases](../../releases) 下载 `ClashVerge-VxKex-Configurator.exe`（约 4 MB）
2. **运行** 右键 EXE → 选择"以管理员身份运行"
3. **配置** 在 GUI 中点击"🚀 一键启用 VxKex"，等待 1-2 分钟

完成！现在可以正常启动 Clash Verge 了。

---

## 🔨 开发者

### 从源码构建

```powershell
# Windows 系统
.\build-win7-native.ps1
# 输出: dist\ClashVerge-VxKex-Configurator.exe
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
├── ClashVerge-VxKex-Configurator.bat    # BAT 启动器
├── VxKexConfigurator.ps1                # PowerShell GUI 主程序
├── build-win7-native.ps1                # IExpress 自动打包脚本
├── BUILD_INSTRUCTIONS.md                # 详细构建文档
├── QUICK_START.md                       # 快速使用指南
├── README.md                            # 本文档
├── resources/
│   └── KexSetup_Release_*.exe          # VxKex 安装包（3.9 MB）
└── dist/
    └── *.exe                            # 构建输出（Git 忽略）
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
- ✅ **Windows 7 SP1**（主要目标，专门优化）
- ✅ Windows 8/8.1/10/11（也支持，但这些版本通常不需要 VxKex）

### Q: 为什么使用 IExpress？

**A:** Windows 原生工具，零依赖，完美兼容 Windows 7

### Q: 杀毒软件报毒？

**A:** 误报。使用 Microsoft 官方工具打包，代码开源可审查

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
