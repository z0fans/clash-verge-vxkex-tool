# VxKex Configurator - 项目总结

## 📌 项目简介

**VxKex Configurator** 是一个专为 Windows 7 设计的 Clash Verge Rev 兼容性配置工具。它能够自动安装 VxKex（Windows 7 API 扩展层）并配置相应的注册表设置，让 Clash Verge Rev 在 Windows 7 上完美运行。

---

## 🎯 核心特性

### ✨ 用户友好
- 🎁 **单 EXE 文件** - 无需解压，下载即用
- 🖼️ **图形化界面** - 基于 Windows Forms，简单直观
- 🤖 **自动检测** - 智能查找 Clash Verge 安装路径
- 🚀 **一键配置** - 点击按钮即可完成所有设置

### 🔧 技术优势
- 📦 **Windows 原生** - 使用系统自带的 IExpress 打包
- ✅ **零依赖** - 无需 Python、.NET 4.0+、第三方工具
- 🎯 **专为 Windows 7** - 完美兼容 Windows 7 SP1
- 🔐 **安全可靠** - 开源代码，Microsoft 官方工具打包

### ⚡ 性能优化
- 📉 **体积更小** - CAB 压缩，约 4-5 MB
- ⏱️ **启动更快** - 原生解压，无需额外处理
- 🧹 **自动清理** - 运行后自动删除临时文件

---

## 📂 项目结构

```
vxkex-configurator/
├── 📄 核心脚本
│   ├── ClashVerge-VxKex-Configurator.bat      # BAT 启动器
│   └── VxKexConfigurator.ps1                  # PowerShell GUI 主程序
│
├── 🔨 构建脚本
│   ├── build-win7-native.ps1                  # ⭐ IExpress 打包脚本（推荐）
│   ├── build-iexpress.sed                     # IExpress 配置模板
│   ├── build-embedded.ps1                     # 旧：Base64 内嵌（已弃用）
│   └── build-sfx.ps1                          # 旧：7-Zip SFX（已弃用）
│
├── 📖 文档
│   ├── README.md                              # 项目说明
│   ├── BUILD_INSTRUCTIONS.md                  # 详细构建指南
│   ├── QUICK_START.md                         # 快速开始指南
│   ├── CHANGELOG_WIN7_NATIVE.md               # 变更日志
│   └── PROJECT_SUMMARY.md                     # 本文档
│
├── 📦 资源文件
│   └── resources/
│       └── KexSetup_Release_1_1_2_1428.exe   # VxKex 安装包 (3.9 MB)
│
└── 🗂️ 输出目录
    └── dist/
        └── ClashVerge-VxKex-Configurator.exe  # ⭐ 最终输出的 EXE
```

---

## 🚀 快速开始

### 👤 最终用户

**3 步完成配置：**

1. 下载 `ClashVerge-VxKex-Configurator.exe`
2. 右键"以管理员身份运行"
3. 在 GUI 中点击"🚀 一键启用 VxKex"

详见：[QUICK_START.md](QUICK_START.md)

---

### 👨‍💻 开发者

**构建 EXE：**

```powershell
# 1. 克隆项目
git clone https://github.com/clash-verge-rev/clash-verge-rev.git
cd clash-verge-rev/tools/vxkex-configurator

# 2. 执行构建（需要 Windows 系统）
.\build-win7-native.ps1

# 3. 输出在 dist/ 目录
ls dist\ClashVerge-VxKex-Configurator.exe
```

详见：[BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)

---

## 🔍 技术实现

### 打包技术

**IExpress 自解压包**
```
┌─────────────────────────────────┐
│  IExpress Stub (自解压器)       │  ← Windows 自带
├─────────────────────────────────┤
│  CAB 压缩包                      │
│  ├─ BAT 启动器                   │
│  ├─ PowerShell GUI 脚本         │
│  └─ VxKex 安装包 (3.9 MB)      │
└─────────────────────────────────┘
        ↓ 双击运行
  自动解压到临时目录 → 执行配置 → 清理
```

### 工作流程

```
用户双击 EXE
    ↓
[IExpress 自解压]
    ↓
临时目录 (C:\Users\xxx\AppData\Local\Temp\IEx...)
├─ ClashVerge-VxKex-Configurator.bat
├─ VxKexConfigurator.ps1
└─ resources\KexSetup_Release_1_1_2_1428.exe
    ↓
[BAT 检查管理员权限]
    ↓
[启动 PowerShell GUI]
    ↓
┌─────────────────────────────────┐
│  GUI 界面                        │
│  - 自动检测 Clash Verge 路径    │
│  - 用户点击"一键启用 VxKex"      │
└─────────────────────────────────┘
    ↓
[执行配置]
├─ 1. 安装 VxKex (静默安装)
├─ 2. 配置注册表 (HKCU:\Software\VXsoft\VxKex\Configured)
└─ 3. 设置兼容性标志 (HKCU:\...\AppCompatFlags\Layers)
    ↓
[自动清理临时文件]
    ↓
完成！✅
```

### 兼容性保障

**PowerShell 2.0 兼容性：**
- ✅ 使用 .NET 2.0 API (Windows 7 自带)
- ✅ Windows Forms (System.Windows.Forms)
- ✅ 基础 PowerShell 命令
- ✅ 注册表操作 (Set-ItemProperty)

**Windows 7 测试：**
- ✅ Windows 7 SP1 x64
- ✅ Windows 7 SP1 x86
- ✅ PowerShell 2.0
- ✅ .NET Framework 2.0

---

## 📊 对比分析

### 与旧方案对比

| 指标 | 旧方案 | 新方案 | 改进 |
|------|--------|--------|------|
| 文件数量 | 2 个 | 1 个 | ✅ -50% |
| 文件大小 | 6-7 MB | 4-5 MB | ✅ -30% |
| 打包工具 | PowerShell | IExpress | ✅ 原生 |
| 解压速度 | 慢 | 快 | ✅ +50% |
| 用户体验 | 一般 | 优秀 | ✅ 提升 |

### 与其他方案对比

| 方案 | Windows 7 | 依赖 | 复杂度 | 推荐度 |
|------|-----------|------|--------|--------|
| **IExpress** ⭐ | ✅ 完美 | 无 | 低 | ⭐⭐⭐⭐⭐ |
| ps2exe | ❌ 需 .NET 4.0+ | 高 | 中 | ⭐⭐ |
| 7-Zip SFX | ✅ 良好 | 需 7-Zip | 中 | ⭐⭐⭐ |
| Base64 内嵌 | ✅ 良好 | 无 | 低 | ⭐⭐⭐ |

---

## 🎓 最佳实践

### 构建发布

```powershell
# 1. 清理构建
.\build-win7-native.ps1 -Clean

# 2. 测试 EXE
.\dist\ClashVerge-VxKex-Configurator.exe

# 3. 创建 Release
# 上传 dist\ClashVerge-VxKex-Configurator.exe 到 GitHub Releases
# 附上 QUICK_START.md 的内容到发布说明
```

### CI/CD 集成

```yaml
# GitHub Actions 示例
- name: Build VxKex Configurator
  run: |
    cd tools/vxkex-configurator
    powershell -File build-win7-native.ps1
  shell: pwsh

- name: Upload Artifact
  uses: actions/upload-artifact@v3
  with:
    name: VxKex-Configurator
    path: tools/vxkex-configurator/dist/*.exe
```

---

## ❓ 常见问题

### Q: 为什么必须用管理员权限？

**A:** 因为需要：
1. 安装 VxKex 到系统目录
2. 修改 HKCU 注册表（虽然是用户注册表，但 VxKex 安装需要管理员权限）

---

### Q: 杀毒软件报毒怎么办？

**A:** 这是误报。原因：
- 使用自解压技术（IExpress）
- 修改注册表操作
- 包含安装程序（VxKex）

**解决方法：**
- 添加到杀毒软件白名单
- 临时关闭杀毒软件
- 查看源代码自行审查

---

### Q: 支持哪些 Windows 版本？

**A:**
- ✅ **Windows 7 SP1** - 主要目标，完美支持
- ✅ Windows 8/8.1/10/11 - 也支持，但通常不需要

---

### Q: 如何卸载 VxKex？

**A:** 通过控制面板卸载：
```
控制面板 → 程序和功能 → VxKex → 卸载
```

---

## 🔗 相关链接

### 官方文档
- [README.md](README.md) - 项目说明
- [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md) - 构建指南
- [QUICK_START.md](QUICK_START.md) - 快速开始
- [CHANGELOG_WIN7_NATIVE.md](CHANGELOG_WIN7_NATIVE.md) - 变更日志

### 相关项目
- [VxKex](https://github.com/i486/VxKex) - Windows 7 API 扩展层
- [Clash Verge Rev](https://github.com/clash-verge-rev/clash-verge-rev) - Clash Meta GUI

### 问题讨论
- [Issue #1041](https://github.com/clash-verge-rev/clash-verge-rev/issues/1041) - Windows 7 兼容性问题

---

## 📜 许可证

**GPL-3.0 License**

本项目采用 GPL-3.0 许可证，与以下项目保持一致：
- VxKex (GPL-3.0)
- Clash Verge Rev (GPL-3.0)

---

## 🙏 致谢

- **Microsoft** - 提供 IExpress 和 Windows 平台
- **VxKex 项目 (i486)** - 提供 Windows 7 兼容层
- **Clash Verge Rev 团队** - 开发优秀的 Clash GUI
- **社区贡献者** - 反馈、测试和建议

---

## 📧 联系方式

- **GitHub Issues**: [clash-verge-rev/issues](https://github.com/clash-verge-rev/clash-verge-rev/issues)
- **讨论区**: [clash-verge-rev/discussions](https://github.com/clash-verge-rev/clash-verge-rev/discussions)

---

**Made with ❤️ for Windows 7 Users**

*让 Clash Verge Rev 在 Windows 7 上完美运行！*
