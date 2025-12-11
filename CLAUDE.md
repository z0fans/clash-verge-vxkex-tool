# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目简介

VxKex 是一套针对 Windows 7 的 API 扩展系统,允许某些 Windows 8/8.1/10 独占应用在 Windows 7 上运行。它通过 IFEO (Image File Execution Options) 机制注入 DLL,然后重写应用程序的 DLL 导入表,将对新版 Windows API 的调用重定向到 VxKex 的扩展 DLL 实现。

## 构建系统

### 构建环境要求
- Visual Studio 2010 或更高版本
- 支持平台: Win32 (x86) 和 x64
- 使用 Visual Studio 解决方案文件构建

### 构建命令
```cmd
# 使用 Visual Studio 打开解决方案
VxKex.sln

# 或使用 MSBuild 命令行构建
msbuild VxKex.sln /p:Configuration=Release /p:Platform=Win32
msbuild VxKex.sln /p:Configuration=Release /p:Platform=x64
```

### 构建配置
- **Debug|Win32**: 32位调试版本
- **Release|Win32**: 32位发布版本
- **Debug|x64**: 64位调试版本
- **Release|x64**: 64位发布版本

## 核心架构

### 组件层次结构

#### 1. 核心注入层
- **VxKexLdr**: 加载器,通过 IFEO `VerifierDlls` 机制将 KexDll 注入到目标进程
- **KexDll**: 核心 DLL,在进程初始化时加载(在 kernel32 之前),只能从 NTDLL 导入
  - `dllmain.c`: DllMain 被调用 3 次(DLL_PROCESS_VERIFIER、两次 DLL_PROCESS_ATTACH)
  - `dllrewrt.c`: DLL 导入表重写逻辑
  - `apiset.c`: API Set 处理
  - `except.c`: 异常处理
  - 运行在 Native 模式,kernel32 加载前执行

#### 2. API 扩展层 (01-Extended DLLs/)
这些 DLL 提供了新版 Windows API 的实现:
- **KxBase**: kernel32.dll/kernelbase.dll 扩展
- **KxUser**: user32.dll 扩展
- **KxAdvapi**: advapi32.dll 扩展
- **KxCom**: COM 相关扩展
- **KxCrt**: C 运行时扩展
- **KxCryp**: bcrypt.dll 等加密 API 扩展
- **KxDx**: DirectX 相关扩展
- **KxMi**: MI (Management Infrastructure) 扩展
- **KxNet**: 网络 API 扩展
- **KxNt**: ntdll.dll 扩展

#### 3. 用户界面层
- **KexShlEx**: Shell 扩展,提供右键菜单属性页配置
- **KexGui**: GUI 配置界面库
- **KexCfg**: 配置程序
- **VxlView**: 日志查看器

#### 4. 支持组件
- **KexSetup**: 安装程序
- **KexW32ML**: Win32 消息循环助手
- **KexPathCch**: 路径处理助手
- **KxCfgHlp**: 配置助手库
- **CpiwBypa**: CPIW (Code Integrity) 绕过
- **KexKMSD**: Kernel Mode Symbol Database

### 关键目录结构

```
00-Common Headers/    # 跨项目共享头文件
  ├── KexVer.h       # 版本定义 (使用 vautogen 自动递增版本号)
  ├── KexTypes.h     # 通用类型定义
  ├── KexDll.h       # KexDll 公共接口
  ├── NtDll.h        # NTDLL 未公开 API 定义
  └── ...

00-Documentation/     # 技术文档
  ├── Notes on IFEO.txt               # IFEO 机制详细说明
  ├── Debugging KexDll.txt            # 使用 WinDbg 调试 KexDll 的步骤
  ├── Application Compatibility List.docx  # 应用兼容性列表
  └── VxKex Registry Keys.docx        # 注册表键说明

00-Import Libraries/  # 导入库文件

01-Extended DLLs/     # API 扩展 DLL 实现
  ├── KxBase/
  ├── KxUser/
  └── ...

01-Development Utilities/  # 开发工具
  └── KexExprt/          # 导出生成工具

02-Prebuilt DLLs/     # 预编译的第三方 DLL
```

### 代码风格约定

#### 文件头格式
所有新源文件必须包含标准头(见 `00-Documentation/Source File Header.txt`):
```c
///////////////////////////////////////////////////////////////////////////////
//
// Module Name:
//
//     file.ext
//
// Abstract:
//
//     [功能描述]
//
// Author:
//
//     Author (DD-MMM-YYYY)
//
// Environment:
//
//     [运行环境: Native mode / Win32 / Kernel mode]
//
// Revision History:
//
//     Author               DD-MMM-YYYY  Initial creation.
//
///////////////////////////////////////////////////////////////////////////////
```

#### 构建配置
每个组件的 `buildcfg.h` 定义:
- `KEX_COMPONENT`: 组件名称
- `KEX_ENV_*`: 环境标识 (NATIVE/WIN32/KERNEL)
- `KEX_TARGET_TYPE_*`: 目标类型 (DLL/EXE)

## 调试说明

### 调试 KexDll
由于 KexDll 在大多数 DLL 和 exe 入口点之前执行,需要特殊调试方法:

1. 在 WinDbg 中打开可执行文件 (File->Open Executable)
2. 在命令窗口输入: `bu KexDll!DllMain` (或其他函数)
3. 重启应用: Debug->Restart
4. WinDbg 将在指定函数处中断并显示源代码、变量、调用栈

### 日志系统
- 使用 VxlView 查看运行时日志
- 日志通过 VXL (VxKex Logging) 系统实现
- `PROTECTED_FUNCTION` 宏用于捕获和记录异常

## 技术关键点

### IFEO 注入机制
- VxKex 利用 `VerifierDlls` 注册表值将 DLL 加载到目标进程
- 不修改任何系统文件,不安装全局钩子
- 配置存储在 `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\[exe名称]`

### DLL 导入表重写
- KexDll 在进程早期修改导入表
- 将对新版 Windows DLL 的导入重定向到 Kx* 扩展 DLL
- 通过这种方式透明地为应用提供新 API 实现

### Native Mode 约束
- KexDll 只能导入 ntdll.dll 中的函数
- 必须处理 kernel32 加载前的环境
- 使用 NT Native API 而非 Win32 API

### 版本管理
- 使用 vautogen 工具自动递增版本号
- 版本信息定义在 `vautogen.h` (自动生成)
- 只在资源文件和需要版本的 .c 文件中包含 (通过 `NEED_VERSION_DEFS`)

## 注意事项

### 安全性
- 本项目涉及系统底层操作和 DLL 注入
- 不应用于恶意目的
- 仅用于合法的应用程序兼容性需求

### 兼容性
- 目标平台: Windows 7 SP1
- 需要 KB2533623 和 KB2670838 更新
- 与 ESU (扩展安全更新) 兼容
