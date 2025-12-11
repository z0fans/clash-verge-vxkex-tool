# Clash Verge VxKex 自动化打包工具

> 为 Clash Verge 在 Windows 7 上提供完整的 VxKex 支持,包含自动化构建和发布系统

[![Build Status](https://github.com/z0fans/clash-verge-vxkex-tool/actions/workflows/build-release.yml/badge.svg)](https://github.com/z0fans/clash-verge-vxkex-tool/actions)
[![License](https://img.shields.io/github/license/z0fans/clash-verge-vxkex-tool)](LICENSE)
[![Downloads](https://img.shields.io/github/downloads/z0fans/clash-verge-vxkex-tool/total)](https://github.com/z0fans/clash-verge-vxkex-tool/releases)

## ✨ 特性

- 🚀 **全自动构建** - 基于 GitHub Actions 的 CI/CD 流程
- 📦 **专业打包** - Inno Setup 安装程序 + 便携版
- ⚡ **智能配置** - 自动检测并配置 Clash Verge
- 🔐 **安全可靠** - SHA256 校验和验证
- 📖 **完整文档** - 从入门到进阶的详细指南

## 🎯 自动配置的文件

安装 VxKex 后,以下 Clash Verge 文件将自动启用 VxKex 支持:

- ✅ `Clash Verge.exe` - 主程序
- ✅ `resources\clash-verge-service.exe` - 服务程序
- ✅ `resources\install-service.exe` - 安装服务
- ✅ `resources\uninstall-service.exe` - 卸载服务

**配置选项:**
- 启用 VxKex
- 禁用子进程继承

## 📥 下载

前往 [Releases](https://github.com/z0fans/clash-verge-vxkex-tool/releases) 页面下载最新版本。

### 文件说明

- `VxKex-{版本}-Setup.exe` - **推荐** - 完整安装程序 (自动配置 Clash Verge)
- `VxKex-{版本}-Portable-x64.zip` - 64位便携版
- `VxKex-{版本}-Portable-x86.zip` - 32位便携版

## 🚀 快速开始

### 用户使用

1. **下载安装程序** - 从 Releases 页面下载 `VxKex-Setup.exe`
2. **运行安装** - 双击安装,或静默安装:
   ```cmd
   VxKex-Setup.exe /VERYSILENT /SUPPRESSMSGBOXES
   ```
3. **自动完成** - 安装程序会自动检测并配置 Clash Verge
4. **启动使用** - 正常启动 Clash Verge 即可

### 开发者构建

查看 [BUILD_GUIDE.md](BUILD_GUIDE.md) 了解如何本地构建和发布。

## 📋 系统要求

- **操作系统**: Windows 7 SP1 或更高版本
- **架构**: x86 (32位) 或 x64 (64位)
- **必需更新**: KB2533623 和 KB2670838 (推荐)
- **ESU 支持**: 是

## 📚 文档

- [快速开始](.github/workflows/quick-start.md) - 5分钟上手
- [完整文档](.github/workflows/README.md) - 详细使用说明
- [构建指南](BUILD_GUIDE.md) - 本地构建和发布
- [架构详解](.github/workflows/ARCHITECTURE.md) - 技术细节
- [配置总结](SETUP_SUMMARY.md) - 系统配置说明

## 🔧 工作原理

VxKex 通过 Windows IFEO (Image File Execution Options) 机制注入 DLL,
在进程初始化时修改导入表,将对新版 Windows API 的调用重定向到 VxKex 实现。

详见 [架构文档](.github/workflows/ARCHITECTURE.md)。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request!

### 发布新版本

只需推送版本标签:

```bash
git tag v1.0.0
git push origin v1.0.0
```

GitHub Actions 会自动构建并发布到 Releases。

## 📜 许可证

本项目基于原 VxKex 项目开发,遵循相同的许可证。

## 🙏 致谢

- [VxKex](https://github.com/i486/VxKex) - 核心项目
- [Clash Verge](https://github.com/clash-verge-rev/clash-verge-rev) - 代理工具
- [Inno Setup](https://jrsoftware.org/isinfo.php) - 安装程序制作

## 📞 支持

- [GitHub Issues](https://github.com/z0fans/clash-verge-vxkex-tool/issues)
- [VxKex 官方仓库](https://github.com/i486/VxKex)

---

**让 Clash Verge 在 Windows 7 上完美运行!** 🎉
