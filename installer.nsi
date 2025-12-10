; Clash Verge VxKex Configurator - NSIS 安装脚本
; 适用于 Windows 7 SP1 及以上版本

;--------------------------------
; Unicode 支持（必需，用于正确显示中文）
Unicode True

;--------------------------------
; 包含必需的头文件
!include "MUI2.nsh"

;--------------------------------
; 常规设置
!define PRODUCT_NAME "Clash Verge VxKex Configurator"
!define PRODUCT_VERSION "4.0.2"
!define PRODUCT_PUBLISHER "Clash Verge Rev Community"
!define PRODUCT_WEB_SITE "https://github.com/z0fans/clash-verge-vxkex-tool"

Name "${PRODUCT_NAME}"
OutFile "dist\ClashVerge-VxKex-Configurator.exe"
InstallDir "$TEMP\ClashVergeVxKex"
RequestExecutionLevel admin
ShowInstDetails show
AutoCloseWindow false

;--------------------------------
; 界面设置
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_HEADERIMAGE
!define MUI_ABORTWARNING
!define MUI_WELCOMEPAGE_TITLE "${PRODUCT_NAME}"
!define MUI_WELCOMEPAGE_TEXT "此工具将为 Clash Verge 配置 VxKex 兼容层，使其能在 Windows 7 上运行。$\r$\n$\r$\n需要管理员权限。点击安装继续。"

;--------------------------------
; 页面
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_INSTFILES

;--------------------------------
; 语言
!insertmacro MUI_LANGUAGE "SimpChinese"

;--------------------------------
; 安装部分
Section "MainSection" SEC01
    SetOutPath "$INSTDIR"
    SetOverwrite on

    ; 解压必需文件
    DetailPrint "解压配置文件..."
    File "ClashVerge-VxKex-Configurator.bat"
    File "VxKexConfigurator.ps1"
    File "resources\KexSetup_Release_1_1_2_1428.exe"

    ; 执行配置脚本
    DetailPrint "正在启动 VxKex 配置工具..."
    DetailPrint "解压路径: $INSTDIR"
    DetailPrint "请在新打开的窗口中完成配置..."

    ; 检查文件是否存在
    IfFileExists "$INSTDIR\KexSetup_Release_1_1_2_1428.exe" +3 0
    DetailPrint "错误: 找不到 VxKex 安装包!"
    Goto cleanup

    ExecWait '"$INSTDIR\ClashVerge-VxKex-Configurator.bat"' $0

    ; 检查执行结果
    IntCmp $0 0 success
    DetailPrint "配置工具返回代码: $0"
    DetailPrint "如果遇到问题,请以管理员身份运行此程序!"
    Goto cleanup

    success:
    DetailPrint "配置成功完成！"

    cleanup:
    ; 清理临时文件
    DetailPrint "清理临时文件..."
    Sleep 1000
    Delete "$INSTDIR\ClashVerge-VxKex-Configurator.bat"
    Delete "$INSTDIR\VxKexConfigurator.ps1"
    Delete "$INSTDIR\KexSetup_Release_1_1_2_1428.exe"
    RMDir "$INSTDIR"

    DetailPrint "完成！"
SectionEnd

;--------------------------------
; 函数：安装完成
Function .onInstSuccess
    MessageBox MB_OK|MB_ICONINFORMATION "VxKex 配置完成！$\r$\n$\r$\n现在可以正常启动 Clash Verge 了。"
FunctionEnd

;--------------------------------
; 函数：安装失败
Function .onInstFailed
    MessageBox MB_OK|MB_ICONSTOP "配置失败！$\r$\n$\r$\n请确保：$\r$\n1. 以管理员身份运行$\r$\n2. 系统为 Windows 7 SP1 或更高版本"
FunctionEnd
