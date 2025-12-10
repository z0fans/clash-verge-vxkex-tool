# VxKex Configurator - Windows 7 原生打包指南

## 🎯 构建目标

将 VxKex Configurator 打包成单个 EXE 文件，专为 **Windows 7 SP1** 设计，使用 Windows 原生的 IExpress 工具。

---

## ✅ 系统要求

### 构建环境
- **操作系统**: Windows 7 SP1 / Windows 8 / Windows 10 / Windows 11
- **PowerShell**: 2.0+ (Windows 7 自带)
- **IExpress**: Windows 自带工具（无需额外安装）

### 目标运行环境
- **操作系统**: Windows 7 SP1 及以上
- **PowerShell**: 2.0+ (Windows 7 自带)
- **.NET Framework**: 2.0+ (Windows 7 自带)
- **管理员权限**: 必需

---

## 📦 文件清单

构建前请确保以下文件存在：

```
vxkex-configurator/
├── ClashVerge-VxKex-Configurator.bat          # BAT 启动器
├── VxKexConfigurator.ps1                      # PowerShell GUI 主程序
├── resources/
│   └── KexSetup_Release_1_1_2_1428.exe       # VxKex 安装包 (3.9 MB)
└── build-win7-native.ps1                      # 构建脚本 (新)
```

---

## 🚀 快速构建

### 方法 1: 使用 PowerShell（推荐）

```powershell
# 1. 打开 PowerShell（无需管理员权限）
# 2. 切换到 vxkex-configurator 目录
cd tools\vxkex-configurator

# 3. 执行构建脚本
.\build-win7-native.ps1

# 4. 完成！输出文件位于:
# dist\ClashVerge-VxKex-Configurator.exe
```

### 方法 2: 清理重新构建

```powershell
# 清理旧文件并重新构建
.\build-win7-native.ps1 -Clean
```

---

## 📋 构建流程说明

脚本会自动执行以下步骤：

1. **检查必需文件** - 验证所有源文件是否存在
2. **准备输出目录** - 创建 `dist` 目录
3. **生成 IExpress 配置** - 动态创建 SED 配置文件
4. **查找 IExpress** - 定位 Windows 自带的 IExpress 工具
5. **执行打包** - 使用 IExpress 打包成单个 EXE

---

## 📤 输出说明

### 输出文件

- **文件名**: `ClashVerge-VxKex-Configurator.exe`
- **路径**: `dist\ClashVerge-VxKex-Configurator.exe`
- **大小**: 约 4-5 MB
- **类型**: Windows 自解压可执行文件

### 文件特性

- ✅ **单文件分发** - 所有资源内嵌，无需解压
- ✅ **Windows 7 原生** - 使用 IExpress，无需第三方工具
- ✅ **自动清理** - 运行后自动清理临时文件
- ✅ **GUI 界面** - 基于 Windows Forms，简单易用

---

## 🎮 使用方法

### 最终用户操作流程

1. **下载 EXE 文件**
   - 从 Releases 下载 `ClashVerge-VxKex-Configurator.exe`

2. **以管理员身份运行**
   - 右键点击 EXE 文件
   - 选择"以管理员身份运行"

3. **在 GUI 中配置**
   - 自动检测或手动选择 Clash Verge 路径
   - 点击"🚀 一键启用 VxKex"按钮
   - 等待配置完成（约 1-2 分钟）

4. **启动 Clash Verge**
   - 配置完成后即可正常使用

---

## 🔧 工作原理

### 打包技术

```
IExpress 自解压包结构:
┌─────────────────────────────────────┐
│  IExpress Stub (自解压器)           │
├─────────────────────────────────────┤
│  CAB 压缩包:                         │
│  ├─ ClashVerge-VxKex-Configurator.bat │
│  ├─ VxKexConfigurator.ps1           │
│  └─ resources/                       │
│     └─ KexSetup_Release_1_1_2_1428.exe │
└─────────────────────────────────────┘
```

### 运行流程

1. 用户双击 EXE → IExpress 自解压到临时目录
2. 运行 `ClashVerge-VxKex-Configurator.bat`
3. BAT 检查管理员权限 → 启动 `VxKexConfigurator.ps1`
4. PowerShell 显示 GUI → 用户配置
5. 安装 VxKex → 配置注册表 → 设置兼容性标志
6. 临时文件自动清理

---

## ❓ 常见问题

### Q: 为什么使用 IExpress 而不是其他工具？

**A:**
- ✅ **Windows 原生** - 所有 Windows 版本都自带（包括 Windows 7）
- ✅ **零依赖** - 无需安装任何第三方工具
- ✅ **稳定可靠** - Microsoft 官方工具，经过充分测试
- ✅ **兼容性好** - 生成的 EXE 兼容 Windows 7 到 Windows 11

### Q: 构建失败怎么办？

**A:** 检查以下项目：
1. 确认所有必需文件都存在
2. 确认在 Windows 系统上运行构建脚本
3. 确认 IExpress 路径正确（通常在 `C:\Windows\System32\iexpress.exe`）
4. 尝试使用 `-Clean` 参数清理重新构建

### Q: 打包的 EXE 可以在哪些 Windows 版本上运行？

**A:**
- ✅ **主要目标**: Windows 7 SP1
- ✅ **也支持**: Windows 8/8.1/10/11（虽然这些版本不需要 VxKex）

### Q: 打包后的 EXE 是否安全？

**A:**
- ✅ 所有源代码都是开源的，可以自行审查
- ✅ 使用 Microsoft 官方的 IExpress 工具打包
- ✅ 不包含任何恶意代码或后门
- ⚠️ 部分杀毒软件可能误报（因为使用自解压技术），这是正常现象

---

## 📝 技术细节

### IExpress SED 配置关键选项

```ini
PackagePurpose=InstallApp          # 用途：安装应用
ShowInstallProgramWindow=0         # 不显示安装程序窗口
HideExtractAnimation=1             # 隐藏解压动画
UseLongFileName=1                  # 使用长文件名
InsideCompressed=0                 # 不使用内部压缩
RebootMode=N                       # 不需要重启
AppLaunched=cmd.exe /c ...         # 解压后执行的命令
```

### PowerShell 兼容性说明

`VxKexConfigurator.ps1` 使用的功能：
- ✅ Windows Forms (System.Windows.Forms) - .NET 2.0+
- ✅ Drawing (System.Drawing) - .NET 2.0+
- ✅ 基础 PowerShell 命令 - PowerShell 2.0+
- ✅ 注册表操作 (Set-ItemProperty) - PowerShell 2.0+

所有功能都兼容 Windows 7 SP1 自带的环境。

---

## 🔗 相关资源

- **IExpress 文档**: [Microsoft Docs](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc736596(v=ws.10))
- **VxKex 项目**: [GitHub - i486/VxKex](https://github.com/i486/VxKex)
- **Clash Verge Rev**: [GitHub - clash-verge-rev](https://github.com/clash-verge-rev/clash-verge-rev)

---

## 📜 许可证

本工具采用 **GPL-3.0** 许可证。

---

**Made with ❤️ for Windows 7 Users**
