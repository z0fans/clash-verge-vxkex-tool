# VxKex GitHub Actions 自动化打包系统 - 配置总结

## ✅ 已完成的配置

本文档总结了为 VxKex 项目配置的完整自动化构建与发布系统。

---

## 📁 创建的文件清单

### 1. GitHub Actions 工作流
- **位置**: `.github/workflows/build-release.yml`
- **功能**: 完整的自动化构建和发布流程
- **触发条件**:
  - 推送 `v*.*.*` 格式的标签 (自动发布)
  - 手动触发 (测试构建)

### 2. 文档文件

| 文件 | 用途 |
|------|------|
| `.github/workflows/README.md` | 完整的工作流使用文档 |
| `.github/workflows/quick-start.md` | 5分钟快速上手指南 |
| `.github/RELEASE_TEMPLATE.md` | Release Notes 模板 |
| `BUILD_GUIDE.md` | 完整构建与发布指南 |
| `CLAUDE.md` | 代码库架构文档 |

---

## 🎯 核心功能

### 1️⃣ 自动化编译
- ✅ 支持 x86 (Win32) 和 x64 双平台
- ✅ 使用 Visual Studio 2019 工具链
- ✅ 完整的 MSBuild 构建流程
- ✅ 自动收集构建产物

### 2️⃣ 智能打包
- ✅ **Inno Setup 安装程序**:
  - 支持静默安装 (`/VERYSILENT`)
  - 多语言支持 (英语/简体中文)
  - 自定义安装向导
  - 自动化卸载程序

- ✅ **便携版 ZIP**:
  - x86 版本
  - x64 版本
  - 免安装即用

- ✅ **文件完整性**:
  - SHA256 校验和自动生成
  - 每个文件独立校验

### 3️⃣ Clash Verge 自动配置 ⭐

这是本次配置的核心亮点!

**自动配置的文件:**
```
✅ Clash Verge.exe
✅ resources\clash-verge-service.exe
✅ resources\install-service.exe
✅ resources\uninstall-service.exe
```

**配置选项:**
- ✅ 启用 VxKex (Enabled = True)
- ✅ 禁用子进程 (DisableForChild = True)
- ✅ 其他选项保持默认

**自动检测路径:**
1. HKLM\SOFTWARE\...\Uninstall\Clash Verge (64位)
2. HKLM\SOFTWARE\...\Uninstall\Clash Verge (32位)
3. HKCU\SOFTWARE\...\Uninstall\Clash Verge
4. %LOCALAPPDATA%\Programs\Clash Verge
5. C:\Program Files\Clash Verge
6. C:\Program Files (x86)\Clash Verge

**实现原理:**

使用 VxKex 官方的 IFEO (Image File Execution Options) 配置机制:

```
HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\
  └── Clash Verge.exe
      ├── UseFilter = 1
      └── VxKex_XXXXXXXX (随机子键)
          ├── FilterFullPath = "完整路径"
          ├── VerifierDlls = "kexdll.dll"
          ├── GlobalFlag = 0x100
          ├── VerifierFlags = 0x80000000
          ├── KEX_DisableForChild = 1
          └── ... (其他配置)
```

### 4️⃣ 版本管理与发布
- ✅ 基于 Git 标签的版本控制
- ✅ 自动创建 GitHub Releases
- ✅ 自动上传构建产物
- ✅ 自动生成 Release Notes 骨架

### 5️⃣ 代码签名支持 (可选)
- ✅ 支持 PFX 证书签名
- ✅ 通过 GitHub Secrets 安全存储
- ✅ 时间戳服务器支持
- ✅ SHA256 签名算法

---

## 🚀 使用流程

### 场景 1: 发布新版本

```bash
# 1. 完成开发和测试
git add .
git commit -m "Release v1.1.4.0: Add new features"
git push origin main

# 2. 创建并推送版本标签
git tag v1.1.4.0
git push origin v1.1.4.0

# 3. GitHub Actions 自动执行:
#    ✓ 编译 x86 + x64 版本
#    ✓ 创建安装程序 (含 Clash Verge 自动配置)
#    ✓ 创建便携版
#    ✓ 生成校验和
#    ✓ 创建 GitHub Release
#    ✓ 上传所有文件

# 4. 10-15分钟后,在 Releases 页面即可下载
```

### 场景 2: 测试构建

```bash
# 在 GitHub Actions 页面手动触发
# 不会创建 Release,产物保存在 Artifacts
```

---

## 📊 构建产物

每次构建生成以下文件:

| 文件名 | 大小估计 | 说明 |
|--------|----------|------|
| `VxKex-{版本}-Setup.exe` | 5-10 MB | Windows 安装程序 |
| `VxKex-{版本}-Portable-x86.zip` | 3-5 MB | 32位便携版 |
| `VxKex-{版本}-Portable-x64.zip` | 4-6 MB | 64位便携版 |
| `VxKex-{版本}-Setup.exe.sha256` | <1 KB | 安装程序校验和 |
| `VxKex-{版本}-Portable-x86.zip.sha256` | <1 KB | x86版校验和 |
| `VxKex-{版本}-Portable-x64.zip.sha256` | <1 KB | x64版校验和 |

---

## 🔧 技术细节

### VxKex 配置机制

参考了官方源代码 `KxCfgHlp/setcfg.c`,完全遵循标准实现:

```c
// 关键配置值
GlobalFlag = 0x100;              // FLG_APPLICATION_VERIFIER
VerifierFlags = 0x80000000;       // 禁用慢速 page heap
VerifierDlls = "kexdll.dll";      // 核心注入 DLL
KEX_DisableForChild = 1;          // 禁用子进程
KEX_DisableAppSpecific = 0;       // 启用应用特定 hack
KEX_WinVerSpoof = 0;              // 无版本伪装
KEX_StrongVersionSpoof = 0;       // 无强版本伪装
```

### Inno Setup 集成

安装程序脚本特点:
- **Unicode 支持**: 正确处理中文路径
- **64位感知**: 自动检测系统架构
- **事务性安装**: 失败自动回滚
- **静默模式**: 支持无人值守安装
- **自定义代码**: Pascal Script 实现高级功能

### GitHub Actions 优化

- **并行构建**: x86 和 x64 可进一步并行化
- **缓存支持**: 可添加 NuGet 和 MSBuild 缓存
- **构建矩阵**: 可扩展支持更多平台
- **工件保留**: 默认保留 30 天

---

## 📝 配置检查清单

在首次使用前,请确认:

### 必需配置
- [x] `.github/workflows/build-release.yml` 已提交
- [x] VxKex 解决方案文件存在 (`VxKex.sln`)
- [x] 所有项目文件和依赖已提交
- [x] GitHub Actions 权限已设置为 "Read and write"

### 可选配置
- [ ] 代码签名证书 (提升信任度)
  - [ ] `CERTIFICATE_BASE64` Secret
  - [ ] `CERTIFICATE_PASSWORD` Secret
- [ ] 自定义安装程序图标
- [ ] 修改默认安装目录
- [ ] 调整 Clash Verge 检测路径

---

## 🎨 自定义指南

### 修改 Clash Verge 检测路径

编辑 `.github/workflows/build-release.yml` 中的 `FindClashVergeInstallPath` 函数:

```pascal
// 添加你的自定义路径
DefaultPath := 'D:\MyCustomPath\Clash Verge';
if DirExists(DefaultPath) then
begin
  Result := DefaultPath;
  Exit;
end;
```

### 修改配置选项

调整 `ConfigureVxKexForExe` 函数中的注册表值:

```pascal
// 启用 Windows 版本伪装为 Windows 10
if not RegWriteDWordValue(HKLM64, IfeoSubkeyPath, 'KEX_WinVerSpoof', 3) then Exit;

// 启用应用特定 hack
if not RegWriteDWordValue(HKLM64, IfeoSubkeyPath, 'KEX_DisableAppSpecific', 0) then Exit;
```

可用的 `KEX_WinVerSpoof` 值:
- `0` - 无伪装
- `1` - Windows 8
- `2` - Windows 8.1
- `3` - Windows 10

### 添加其他应用的自动配置

复制 `AutoConfigureClashVerge` 函数并修改:

```pascal
procedure AutoConfigureMyApp;
var
  AppPath: String;
begin
  AppPath := 'C:\Program Files\MyApp';
  if DirExists(AppPath) then
  begin
    ConfigureVxKexForExe(AppPath + '\MyApp.exe', True);
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    AutoConfigureClashVerge;
    AutoConfigureMyApp;  // 添加你的应用
  end;
end;
```

---

## 🐛 常见问题

### Q1: 构建失败怎么办?

**A**: 查看 Actions 日志:
1. 进入 **Actions** 页面
2. 点击失败的工作流
3. 展开失败的步骤
4. 查看详细错误信息

常见原因:
- 项目文件路径错误
- 缺少依赖
- Inno Setup 脚本语法错误

### Q2: Clash Verge 未自动配置?

**A**: 检查日志中的 "Auto-configuring Clash Verge" 部分:
- 如果显示 "not found",可能需要添加自定义检测路径
- 如果显示文件不存在,检查 Clash Verge 版本和文件结构

### Q3: 如何验证配置是否生效?

**A**: 安装后检查注册表:
```cmd
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\Clash Verge.exe" /s
```

应该看到 `UseFilter = 1` 和 `VxKex_XXXXXXXX` 子键。

### Q4: 能否禁用 Clash Verge 自动配置?

**A**: 可以,在工作流的 Inno Setup 脚本中注释掉:

```pascal
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    // AutoConfigureClashVerge;  // <- 注释这行
  end;
end;
```

---

## 📚 下一步

1. **测试构建**: 手动触发一次测试构建
2. **创建标签**: 推送第一个版本标签
3. **验证 Release**: 检查自动创建的 Release
4. **测试安装**: 下载并测试安装程序
5. **配置签名**: (可选) 设置代码签名
6. **编写文档**: 为用户准备使用说明

---

## 🤝 支持与反馈

如有问题或建议:
- 查看 [完整文档](.github/workflows/README.md)
- 阅读 [快速开始指南](.github/workflows/quick-start.md)
- 参考 [构建指南](BUILD_GUIDE.md)
- 提交 [GitHub Issue](https://github.com/YOUR_REPO/issues)

---

## 📄 相关文档

- [VxKex 项目主页](https://github.com/i486/VxKex)
- [Inno Setup 文档](https://jrsoftware.org/ishelp/)
- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [MSBuild 参考](https://docs.microsoft.com/en-us/visualstudio/msbuild/)

---

## 🎉 总结

您现在拥有一套完整的 **专业级 Windows 应用自动化打包系统**,包括:

✅ **自动化构建** - 无需手动编译
✅ **智能打包** - 安装程序 + 便携版
✅ **自动配置** - Clash Verge 零配置支持
✅ **版本管理** - 基于 Git 标签
✅ **自动发布** - GitHub Releases 集成
✅ **代码签名** - 可选的信任提升
✅ **完整文档** - 从入门到进阶

**这是行业标准的 CI/CD 最佳实践!** 🚀

---

*最后更新: 2025-12-11*
