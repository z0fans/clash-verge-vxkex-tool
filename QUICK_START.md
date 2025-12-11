# VxKex Configurator - 快速开始指南

## 📥 下载

从 [Releases](../../releases) 下载：
- **ClashVerge-VxKex-Configurator.exe**（约 4-5 MB）

---

## 🚀 使用步骤（3 步完成）

### 步骤 1: 右键以管理员身份运行

```
右键点击 ClashVerge-VxKex-Configurator.exe
→ 选择"以管理员身份运行"
```

⚠️ **必须**以管理员身份运行！否则无法安装 VxKex 和修改注册表。

---

### 步骤 2: 选择 Clash Verge 路径

工具会自动检测 Clash Verge 安装路径：
- ✅ 如果自动检测成功 → 直接进入步骤 3
- ❌ 如果未检测到 → 点击"浏览..."按钮，手动选择 `Clash Verge.exe`

**常见安装位置：**
```
C:\Program Files\Clash Verge\Clash Verge.exe
C:\Program Files (x86)\Clash Verge\Clash Verge.exe
%LOCALAPPDATA%\Programs\Clash Verge\Clash Verge.exe
```

---

### 步骤 3: 一键配置

点击绿色按钮：**🚀 一键启用 VxKex**

等待约 1-2 分钟，工具会：
1. 安装 VxKex（Windows 7 兼容层）
2. 配置注册表
3. 设置兼容性标志

看到 **✅ 配置成功！** 即完成。

---

## ✅ 验证配置

### 方法 1: 使用诊断工具（推荐）

配置完成后，运行诊断工具验证：

```batch
双击运行: VxKex-Diagnostic.bat
```

诊断工具会自动检查：
- ✅ VxKex 安装目录是否存在
- ✅ VxKex 注册表项是否正确
- ✅ Clash Verge 配置是否完成
- ✅ VxKexLoader.dll 是否存在
- ✅ 兼容性标志是否设置

**诊断结果：**
- ✅ "VxKex 已正确安装" → 配置成功，可以启动 Clash Verge
- ❌ "VxKex 可能未正确安装" → 查看故障排除指南

### 方法 2: 直接测试

配置完成后，双击启动 **Clash Verge.exe**：

- ✅ **成功** - 程序正常启动，显示主界面
- ❌ **失败** - 仍然报错 `0xc0000005`

如果失败，请：
1. 运行 `VxKex-Diagnostic.bat` 诊断问题
2. 查阅 [TROUBLESHOOTING.md](TROUBLESHOOTING.md) 故障排除指南
3. 尝试手动安装 VxKex（见下方）

---

## 🔧 手动安装 VxKex（高级）

如果自动配置工具的静默安装失败，可以使用手动安装工具：

### 使用手动安装工具

```batch
双击运行: VxKex-Manual-Install.bat
```

**安装选项：**
1. **图形界面安装**（推荐）
   - 可以看到完整的安装过程
   - 显示安装进度和详细信息
   - 适合需要了解安装细节的用户

2. **静默安装**
   - 与自动配置工具相同的方式
   - 适合自动化脚本

**安装完成后：**
1. 运行 `VxKex-Diagnostic.bat` 验证安装
2. 如果验证通过，运行 `ClashVerge-VxKex-Configurator.bat` 配置 Clash Verge

---

## 🛠️ 可用工具一览

| 工具 | 用途 | 使用场景 |
|------|------|----------|
| **ClashVerge-VxKex-Configurator.bat** | 一键安装和配置 | 首次安装（推荐） |
| **VxKex-Diagnostic.bat** | 诊断验证 | 验证安装状态 |
| **VxKex-Manual-Install.bat** | 手动安装 VxKex | 静默安装失败时 |

---

## ❓ 常见问题

### Q1: 软件安装成功，但不确定 VxKex 是否安装？

**A:** 运行 `VxKex-Diagnostic.bat` 诊断工具，它会全面检查 VxKex 的安装状态。

---

### Q2: 提示"需要管理员权限"

**A:** 必须右键选择"以管理员身份运行"，不能直接双击。

---

### Q3: 找不到 Clash Verge.exe

**A:** 手动浏览到 Clash Verge 安装目录，选择 `Clash Verge.exe` 文件。

---

### Q4: 配置后仍然报错 0xc0000005

**A:** 按照以下步骤排查：
1. 运行 `VxKex-Diagnostic.bat` 诊断问题
2. 查阅 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
3. 尝试使用 `VxKex-Manual-Install.bat` 重新安装
4. 重启计算机后再次测试

---

### Q5: 杀毒软件报毒

**A:** 这是误报！原因：
- 使用了 NSIS 自解压技术
- 需要修改注册表
- 建议：将 EXE 添加到白名单，或临时关闭杀毒软件

---

### Q6: 配置工具是否安全？

**A:**
- ✅ 开源代码，可自行审查
- ✅ 使用 NSIS（业界标准安装工具）打包
- ✅ 仅修改注册表，不修改程序文件
- ✅ 不包含任何恶意代码

---

## 🔗 更多帮助

- **详细说明**: [README.md](README.md)
- **故障排除**: [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **构建指南**: [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)
- **更新日志**: [CHANGELOG.md](CHANGELOG.md)
- **问题反馈**: [GitHub Issues](https://github.com/clash-verge-rev/clash-verge-rev/issues)
- **VxKex 项目**: [GitHub - VxKex](https://github.com/i486/VxKex)

---

## 📋 支持的系统

- ✅ Windows 7 SP1（主要目标）
- ✅ Windows 8/8.1/10/11（也支持）

---

**🎉 享受 Clash Verge 在 Windows 7 上的完美体验！**
