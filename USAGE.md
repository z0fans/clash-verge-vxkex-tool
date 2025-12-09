# 快速使用指南

## 🎯 给用户的使用说明

### 步骤 1：下载工具

下载 `ClashVerge-VxKex-Configurator.exe`（约 8-10 MB）

### 步骤 2：运行工具

**重要：必须以管理员身份运行！**

**方法 1：右键菜单**
1. 右键点击 `ClashVerge-VxKex-Configurator.exe`
2. 选择 **"以管理员身份运行"**

**方法 2：命令行**
```cmd
# 在管理员 CMD 中运行
ClashVerge-VxKex-Configurator.exe
```

### 步骤 3：一键配置

1. 工具会自动打开图形界面
2. 自动检测环境和安装路径
3. 点击 **"一键启用 VxKex"** 按钮
4. 等待 1-2 分钟（会自动安装 VxKex）
5. 看到 "配置完成" 提示
6. ✅ 完成！

### 步骤 4：启动 Clash Verge

现在可以正常启动 Clash Verge Rev 了，不会再报错！

---

## 🔧 给开发者的构建说明

### 环境准备

```bash
# 1. 安装 Python 3.8+
# 从 python.org 下载安装

# 2. 验证安装
python --version
pip --version
```

### 构建步骤

```bash
# 1. 进入工具目录
cd tools/vxkex-configurator

# 2. 安装依赖
pip install -r requirements.txt

# 3. 运行构建脚本（Windows）
build.bat

# 或手动构建
pyinstaller build.spec
```

### 构建产物

```
dist/
└── ClashVerge-VxKex-Configurator.exe   # 单文件可执行程序
```

**文件说明：**
- 大小：约 8-10 MB
- 包含：Python 运行时 + GUI 代码 + VxKex 安装包（3.9 MB）
- 特点：单文件，无需额外依赖

---

## 🧪 测试指南

### 测试前准备

1. 准备 Windows 7 测试机（或虚拟机）
2. 安装 Clash Verge Rev v1.6.2+
3. **不要**手动安装 VxKex

### 测试流程

**测试 1：首次安装**
```
1. 运行工具（以管理员身份）
2. 应该显示 "VxKex 未安装"
3. 点击 "一键启用 VxKex"
4. 观察：
   - 显示 "正在安装 VxKex"
   - 显示 "正在配置 Clash Verge"
   - 显示 "配置完成！成功配置了 4 个可执行文件"
5. 启动 Clash Verge，应该正常运行
```

**测试 2：已安装 VxKex**
```
1. 手动安装 VxKex
2. 运行工具
3. 应该显示 "VxKex 已安装"
4. 点击 "一键启用 VxKex"
5. 应该跳过安装步骤，直接配置
```

**测试 3：手动选择路径**
```
1. 运行工具
2. 如果自动检测失败，点击 "浏览..."
3. 选择 Clash Verge 安装目录
4. 点击 "一键启用 VxKex"
5. 应该正常配置
```

**测试 4：错误处理**
```
1. 测试无管理员权限：应该提示需要管理员权限
2. 测试错误路径：应该提示路径无效
3. 测试缺少文件：应该跳过不存在的文件
```

---

## 📊 技术细节

### 工具工作流程

```
启动
  ↓
检查管理员权限 → 如果没有 → 请求提升权限
  ↓
创建 GUI 界面
  ↓
自动检测：
  ├─ 检查 VxKex 是否安装
  └─ 检测 Clash Verge 安装路径
  ↓
用户点击 "一键启用 VxKex"
  ↓
如果 VxKex 未安装：
  ├─ 解压内置的 VxKex 安装包
  ├─ 静默安装 VxKex
  └─ 验证安装成功
  ↓
配置注册表（4 个 exe）：
  ├─ Clash Verge.exe
  ├─ clash-verge-service.exe
  ├─ install-service.exe
  └─ uninstall-service.exe
  ↓
显示 "配置完成"
```

### 注册表修改

对每个 exe 文件，在以下位置创建配置：

```
HKEY_LOCAL_MACHINE\
  SOFTWARE\
    Microsoft\
      Windows NT\
        CurrentVersion\
          Image File Execution Options\
            [程序名.exe]\
              VerifierDlls = "VxKexLdr.dll" (REG_SZ)
              GlobalFlag = 0x100 (REG_DWORD)
              DisableChildVxKex = 1 (REG_DWORD)
```

### PyInstaller 打包配置

- **模式：** 单文件（onefile）
- **控制台：** 禁用（GUI 程序）
- **UAC：** 请求管理员权限
- **UPX 压缩：** 启用
- **包含资源：** VxKex 安装包（3.9 MB）

---

## ❓ 故障排除

### 问题 1：提示需要管理员权限

**解决：** 右键 → 以管理员身份运行

### 问题 2：找不到 Clash Verge 安装路径

**解决：** 点击 "浏览..." 手动选择

### 问题 3：VxKex 安装失败

**原因可能：**
- 杀毒软件拦截
- 系统环境异常

**解决：**
1. 关闭杀毒软件
2. 手动从 [VxKex Releases](https://github.com/i486/VxKex/releases) 下载安装
3. 然后重新运行工具

### 问题 4：配置后还是无法运行

**检查：**
1. 运行工具查看日志
2. 检查注册表是否正确配置
3. 确认 Windows 7 已安装 SP1
4. 确认已安装 WebView2 Runtime

---

## 📝 开发日志

### v1.0.0 (2024-12-10)

**功能：**
- ✅ 自动安装 VxKex
- ✅ 自动检测 Clash Verge 路径
- ✅ 图形界面
- ✅ 一键配置 4 个 exe
- ✅ 日志输出
- ✅ 管理员权限检查

**技术栈：**
- Python 3.8+
- tkinter (GUI)
- winreg (注册表)
- PyInstaller (打包)

**测试环境：**
- Windows 7 SP1 x64
- Windows 10 x64

---

## 🔗 相关资源

- **VxKex 项目：** https://github.com/i486/VxKex
- **Issue #1041：** https://github.com/clash-verge-rev/clash-verge-rev/issues/1041
- **Clash Verge Rev：** https://github.com/clash-verge-rev/clash-verge-rev
