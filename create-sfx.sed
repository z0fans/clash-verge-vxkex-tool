[Version]
Class=IEXPRESS
SEDVersion=3
[Options]
PackagePurpose=InstallApp
ShowInstallProgramWindow=0
HideExtractAnimation=1
UseLongFileName=1
InsideCompressed=0
CAB_FixedSize=0
CAB_ResvCodeSigning=0
RebootMode=N
InstallPrompt=%InstallPrompt%
DisplayLicense=%DisplayLicense%
FinishMessage=%FinishMessage%
TargetName=%TargetName%
FriendlyName=%FriendlyName%
AppLaunched=%AppLaunched%
PostInstallCmd=%PostInstallCmd%
AdminQuietInstCmd=%AdminQuietInstCmd%
UserQuietInstCmd=%UserQuietInstCmd%
SourceFiles=SourceFiles

[Strings]
InstallPrompt=此工具将帮助您在 Windows 7 上配置 Clash Verge 的 VxKex 兼容性。点击"是"继续。
DisplayLicense=
FinishMessage=配置工具已启动,请在弹出的窗口中完成配置。
TargetName=.\dist\ClashVerge-VxKex-Configurator.exe
FriendlyName=Clash Verge VxKex 一键配置工具
AppLaunched=cmd /c ClashVerge-VxKex-Configurator.bat
PostInstallCmd=<None>
AdminQuietInstCmd=
UserQuietInstCmd=
FILE0="ClashVerge-VxKex-Configurator.bat"
FILE1="VxKexConfigurator.ps1"
FILE2="resources\KexSetup_Release_1_1_2_1428.exe"

[SourceFiles]
SourceFiles0=.
[SourceFiles0]
%FILE0%=
%FILE1%=
SourceFiles1=.\resources
[SourceFiles1]
%FILE2%=
