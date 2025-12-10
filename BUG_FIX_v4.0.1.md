# 🐛 Bug 修复说明 - v4.0.1

## 问题描述

在 v4.0.0 版本中，VxKex Configurator 在 Windows 7 上运行时会出现以下问题：

### 症状
- ✅ NSIS 安装界面正常显示
- ✅ 点击"安装"后开始解压文件
- ❌ 弹出红色命令提示符窗口显示错误
- ❌ 窗口闪现后自动关闭
- ❌ 配置失败

### 错误信息（在命令提示符窗口中）
```
❌ 错误: 找不到 VxKex 安装包
路径: C:\Users\...\Temp\ClashVergeVxKex\resources\KexSetup_Release_1_1_2_1428.exe
```

---

## 🔍 根本原因

### 路径配置不匹配

**NSIS 安装脚本**（`installer.nsi:49`）：
```nsis
File "resources\KexSetup_Release_1_1_2_1428.exe"
```
这会把文件解压到：
```
C:\Users\...\Temp\ClashVergeVxKex\KexSetup_Release_1_1_2_1428.exe
```
注意：**没有** `resources` 子目录

**PowerShell 脚本**（`VxKexConfigurator.ps1:8`）原代码：
```powershell
$script:VxKexInstallerPath = "$PSScriptRoot\resources\KexSetup_Release_1_1_2_1428.exe"
```
期望文件在：
```
C:\Users\...\Temp\ClashVergeVxKex\resources\KexSetup_Release_1_1_2_1428.exe
```

**结果：路径不存在 → 文件找不到 → 显示错误并退出**

---

## ✅ 修复方案

### 修改内容

**文件：`VxKexConfigurator.ps1`**

```diff
# 全局变量
- $script:VxKexInstallerPath = "$PSScriptRoot\resources\KexSetup_Release_1_1_2_1428.exe"
+ $script:VxKexInstallerPath = "$PSScriptRoot\KexSetup_Release_1_1_2_1428.exe"
$script:ClashVergeExePath = ""
```

**文件：`installer.nsi`**

增加了文件存在性检查和更详细的错误提示：
```nsis
; 检查文件是否存在
IfFileExists "$INSTDIR\KexSetup_Release_1_1_2_1428.exe" +3 0
DetailPrint "错误: 找不到 VxKex 安装包!"
Goto cleanup
```

---

## 🚀 如何应用修复

### 方式 1: 使用修复后的源码重新构建（推荐）

```batch
# 在 Windows 系统上执行
cd tools\vxkex-configurator

# 确保 NSIS 已安装
# choco install nsis -y

# 重新构建
makensis installer.nsi

# 输出: dist\ClashVerge-VxKex-Configurator.exe (v4.0.1+)
```

### 方式 2: 手动修复已解压的文件（临时方案）

如果您已经运行了 v4.0.0 版本并遇到错误：

1. 找到临时解压目录（通常在 `C:\Users\<用户名>\AppData\Local\Temp\ClashVergeVxKex\`）

2. 编辑 `VxKexConfigurator.ps1` 文件，修改第 8 行：
   ```powershell
   # 将这行:
   $script:VxKexInstallerPath = "$PSScriptRoot\resources\KexSetup_Release_1_1_2_1428.exe"

   # 改为:
   $script:VxKexInstallerPath = "$PSScriptRoot\KexSetup_Release_1_1_2_1428.exe"
   ```

3. 以管理员身份运行 `ClashVerge-VxKex-Configurator.bat`

---

## 🧪 测试验证

### 修复后的预期行为

1. ✅ 运行安装器，点击"安装"
2. ✅ 弹出 PowerShell GUI 窗口（正常的蓝色窗口）
3. ✅ 选择 Clash Verge 可执行文件路径
4. ✅ 点击"🚀 一键启用 VxKex"
5. ✅ 显示安装进度：
   ```
   [时间戳] 开始安装 VxKex...
   [时间戳] 运行 VxKex 安装程序...
   [时间戳] ✓ VxKex 安装成功
   [时间戳] 配置 Clash Verge 兼容性设置...
   [时间戳] ✓ 兼容性设置配置成功
   [时间戳] ✅ 配置完成！
   ```
6. ✅ 显示成功提示框

### 如何验证修复成功

**方法 1: 检查版本号**
```powershell
# 打开修复后的 installer.nsi
# 确认版本号已更新:
!define PRODUCT_VERSION "4.0.1"
```

**方法 2: 运行测试**
- 在 Windows 7 系统上运行新构建的安装器
- 应该能够正常安装并配置 VxKex
- 不会出现红色错误窗口

---

## 📊 版本对比

| 版本 | 状态 | 问题 |
|------|------|------|
| v4.0.0 | ❌ 有 Bug | 路径配置错误，无法找到 VxKex 安装包 |
| v4.0.1 | ✅ 已修复 | 路径配置正确，增加错误检查 |

---

## 🔧 额外改进

除了修复核心 bug，还进行了以下改进：

1. **增强错误检查**
   - NSIS 脚本中添加文件存在性验证
   - 更详细的错误提示信息

2. **改进调试输出**
   - 显示解压路径，方便排查问题
   - 明确提示需要管理员权限

3. **更好的用户体验**
   - 清晰的错误信息
   - 明确的故障排除提示

---

## 🙏 致谢

感谢用户报告此问题并提供详细的错误截图，帮助我们快速定位和修复 bug。

---

## 📝 更新日志

### v4.0.1 (2025-12-10)
- 🐛 **修复**: PowerShell 脚本中 VxKex 安装包路径配置错误
- ✨ **新增**: NSIS 脚本中的文件存在性检查
- 📝 **改进**: 更详细的错误提示和调试信息

### v4.0.0 (2025-12-09)
- 🎉 初始发布
- ❌ 已知问题: 路径配置错误导致安装失败

---

**修复完成日期**: 2025-12-10
**测试状态**: 待在 Windows 7 系统上验证
**发布状态**: 准备发布 v4.0.1
