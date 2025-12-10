; Clash Verge VxKex Configurator - NSIS 安装脚本
; 适用于 Windows 7 SP1 及以上版本

;--------------------------------
; 包含必需的头文件
!include "MUI2.nsh"
!include "FileFunc.nsh"

;--------------------------------
; 常规设置
!define PRODUCT_NAME "Clash Verge VxKex Configurator"
!define PRODUCT_VERSION "4.0.0"
!define PRODUCT_PUBLISHER "Clash Verge Rev Community"
!define PRODUCT_WEB_SITE "https://github.com/z0fans/clash-verge-vxkex-tool"

Name "${PRODUCT_NAME}"
OutFile "dist\ClashVerge-VxKex-Configurator.exe"
InstallDir "$TEMP\ClashVergeVxKex"
RequestExecutionLevel admin
ShowInstDetails hide
AutoCloseWindow true

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
    File "ClashVerge-VxKex-Configurator.bat"
    File "VxKexConfigurator.ps1"
    File "resources\KexSetup_Release_1_1_2_1428.exe"

    ; 执行配置脚本
    DetailPrint "正在启动 VxKex 配置工具..."
    ExecWait '"$INSTDIR\ClashVerge-VxKex-Configurator.bat"' $0

    ; 清理临时文件
    DetailPrint "清理临时文件..."
    Delete "$INSTDIR\ClashVerge-VxKex-Configurator.bat"
    Delete "$INSTDIR\VxKexConfigurator.ps1"
    Delete "$INSTDIR\KexSetup_Release_1_1_2_1428.exe"
    RMDir "$INSTDIR"

    DetailPrint "配置完成！"
SectionEnd

;--------------------------------
; 函数：初始化
Function .onInit
    ; 检查 Windows 版本
    ${If} ${AtLeastWin7}
        ; 继续安装
    ${Else}
        MessageBox MB_ICONSTOP "此工具需要 Windows 7 或更高版本！"
        Abort
    ${EndIf}
FunctionEnd

;--------------------------------
; 函数：安装完成
Function .onInstSuccess
    MessageBox MB_OK "VxKex 配置工具已启动，请在窗口中完成配置。"
FunctionEnd

;--------------------------------
; 函数：安装失败
Function .onInstFailed
    MessageBox MB_ICONSTOP "配置失败！请检查管理员权限和系统要求。"
FunctionEnd
