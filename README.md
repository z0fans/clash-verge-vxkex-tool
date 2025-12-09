# Clash Verge VxKex 一键配置工具

> 🚀 让 Clash Verge Rev 在 Windows 7 上一键启动！

## 📋 问题背景

Clash Verge Rev v1.6.2+ 版本在 Windows 7 上启动时会报错 `0xc0000005`（应用程序错误），原因是程序调用了 Windows 8+ 才有的 API 函数。

**手动解决方案很复杂**：
1. 下载并安装 VxKex
2. 找到 Clash Verge 安装目录
3. 右键 4 个不同的 exe 文件
4. 分别打开属性 → VxKex 选项卡
5. 勾选各种选项...

**现在只需要一键！**

---

## ✨ 功能特性

- ✅ **一键完成**：无需任何手动操作
- ✅ **自动安装 VxKex**：内置 VxKex 安装包（v1.1.2）
- ✅ **自动检测路径**：自动找到 Clash Verge 安装位置
- ✅ **图形界面**：简单直观，老少皆宜
- ✅ **自动配置**：配置所有必需的 4 个 exe 文件
- ✅ **安全可靠**：开源代码，可审计

---

## 🎯 使用方法

### 方式 1：使用预编译的 exe（推荐）

1. 下载 `ClashVerge-VxKex-Configurator.exe`
2. **右键 → 以管理员身份运行**
3. 点击 **"一键启用 VxKex"** 按钮
4. 等待完成（约 1-2 分钟）
5. ✅ 完成！现在可以启动 Clash Verge 了

### 方式 2：从源码运行

**前置要求：**
- Python 3.8+
- Windows 7 SP1 或更高版本

**步骤：**

```bash
# 1. 进入工具目录
cd tools/vxkex-configurator

# 2. 安装依赖
pip install -r requirements.txt

# 3. 以管理员身份运行 CMD，然后执行
python main.py
```

---

## 🔧 工具原理

### VxKex 是什么？

[VxKex](https://github.com/i486/VxKex) 是 Windows 7 API 扩展层，可以让调用 Windows 8/10/11 API 的程序在 Windows 7 上运行。

### 本工具做了什么？

1. **检测 VxKex**：检查系统是否已安装 VxKex
2. **自动安装**：如果未安装，静默安装内置的 VxKex
3. **检测路径**：自动找到 Clash Verge 安装目录
4. **配置注册表**：为以下 4 个文件配置 IFEO (Image File Execution Options)：
   - `Clash Verge.exe`
   - `resources\clash-verge-service.exe`
   - `resources\install-service.exe`
   - `resources\uninstall-service.exe`

### 注册表配置详情

对于每个 exe，在以下位置创建配置：
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\[程序名.exe]
```

设置值：
- `VerifierDlls` = `VxKexLdr.dll`
- `GlobalFlag` = `0x100`
- `DisableChildVxKex` = `1`

---

## 🏗️ 构建指南

### 环境要求

- Windows 系统
- Python 3.8 或更高版本
- pip 包管理器

### 构建步骤

```bash
# 1. 进入工具目录
cd tools/vxkex-configurator

# 2. 安装依赖
pip install -r requirements.txt

# 3. 运行构建脚本
build.bat

# 或手动执行
pyinstaller build.spec
```

### 构建产物

- 位置：`dist/ClashVerge-VxKex-Configurator.exe`
- 大小：约 8-10 MB（包含 VxKex 安装包 3.9 MB）
- 特点：单文件，无需额外依赖

---

## 📂 目录结构

```
vxkex-configurator/
├── main.py                                    # 主程序（Python + tkinter GUI）
├── build.spec                                 # PyInstaller 配置
├── build.bat                                  # Windows 构建脚本
├── requirements.txt                           # Python 依赖
├── README.md                                  # 本文档
└── resources/
    └── KexSetup_Release_1_1_2_1428.exe       # VxKex 安装包（3.9 MB）
```

---

## ❓ 常见问题

### Q: 为什么需要管理员权限？

**A:** 因为需要：
1. 安装 VxKex 到系统目录
2. 修改 `HKEY_LOCAL_MACHINE` 注册表

### Q: 会修改 Clash Verge 程序吗？

**A:** 不会！本工具只修改 Windows 注册表，不修改任何程序文件。

### Q: 如何卸载/恢复？

**A:** 删除注册表项即可：
```
HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Clash Verge.exe
```
（以及其他 3 个 exe 的对应项）

或者使用注册表编辑器手动删除。

### Q: 支持哪些 Windows 版本？

**A:**
- ✅ Windows 7 SP1（主要目标）
- ✅ Windows 8/8.1
- ✅ Windows 10/11（虽然不需要，但也能用）

### Q: VxKex 安装包从哪来的？

**A:** 来自 VxKex 官方 GitHub Releases：
https://github.com/i486/VxKex/releases/tag/v1.1.2.1428

### Q: 安全吗？会不会有病毒？

**A:**
- ✅ 代码开源，可以审计
- ✅ VxKex 来自官方仓库
- ✅ 不联网，不上传数据
- ✅ 只修改注册表，不修改程序文件

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
- [VxKex 文档](https://clash-verge-rev.github.io/faq/windows.html#windows-7-无法使用) - Windows 7 解决方案

---

## 🙏 致谢

- [VxKex](https://github.com/i486/VxKex) 项目提供 Windows 7 兼容层
- [Clash Verge Rev](https://github.com/clash-verge-rev/clash-verge-rev) 社区
- 所有在 Issue #1041 中提供反馈的用户

---

## ⚠️ 免责声明

- 本工具仅用于配置目的，不修改 Clash Verge 程序本身
- 修改注册表有风险，使用前建议备份
- 作者不对使用本工具造成的任何问题负责
- VxKex 和 Clash Verge 的所有权归各自作者所有

---

**Made with ❤️ for Clash Verge Rev Community**

如有问题或建议，请在 [GitHub Issues](https://github.com/clash-verge-rev/clash-verge-rev/issues) 中反馈。
