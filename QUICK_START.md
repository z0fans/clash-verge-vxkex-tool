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

配置完成后，双击启动 **Clash Verge.exe**：

- ✅ **成功** - 程序正常启动，显示主界面
- ❌ **失败** - 仍然报错 `0xc0000005`

如果失败，请检查：
1. 是否以管理员身份运行了配置工具
2. 是否选择了正确的 Clash Verge.exe 路径
3. Windows 7 是否安装了 SP1 补丁

---

## ❓ 常见问题

### Q1: 提示"需要管理员权限"

**A:** 必须右键选择"以管理员身份运行"，不能直接双击。

---

### Q2: 找不到 Clash Verge.exe

**A:** 手动浏览到 Clash Verge 安装目录，选择 `Clash Verge.exe` 文件。

---

### Q3: 配置后仍然报错 0xc0000005

**A:** 尝试以下步骤：
1. 重启计算机
2. 再次以管理员身份运行配置工具
3. 确认 Windows 7 已安装 SP1

---

### Q4: 杀毒软件报毒

**A:** 这是误报！原因：
- 使用了 IExpress 自解压技术
- 需要修改注册表
- 建议：将 EXE 添加到白名单，或临时关闭杀毒软件

---

### Q5: 配置工具是否安全？

**A:**
- ✅ 开源代码，可自行审查
- ✅ 使用 Microsoft 官方 IExpress 打包
- ✅ 仅修改注册表，不修改程序文件
- ✅ 不包含任何恶意代码

---

## 🔗 更多帮助

- **详细说明**: [README.md](README.md)
- **构建指南**: [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)
- **问题反馈**: [GitHub Issues](https://github.com/clash-verge-rev/clash-verge-rev/issues)
- **VxKex 项目**: [GitHub - VxKex](https://github.com/i486/VxKex)

---

## 📋 支持的系统

- ✅ Windows 7 SP1（主要目标）
- ✅ Windows 8/8.1/10/11（也支持）

---

**🎉 享受 Clash Verge 在 Windows 7 上的完美体验！**
