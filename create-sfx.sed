[Version]
Class=IEXPRESS
SEDVersion=3

[Options]
PackagePurpose=InstallApp
ShowInstallProgramWindow=0
HideExtractAnimation=0
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
InstallPrompt=This tool will help you configure VxKex for Clash Verge on Windows 7. Click Yes to continue.
DisplayLicense=
FinishMessage=Configuration tool started. Please complete the setup in the GUI window.
TargetName=dist\ClashVerge-VxKex-Configurator.exe
FriendlyName=Clash Verge VxKex Configurator
AppLaunched=cmd.exe /c ClashVerge-VxKex-Configurator.bat
PostInstallCmd=<None>
AdminQuietInstCmd=
UserQuietInstCmd=
FILE0="ClashVerge-VxKex-Configurator.bat"
FILE1="VxKexConfigurator.ps1"
FILE2="resources\KexSetup_Release_1_1_2_1428.exe"

[SourceFiles]
SourceFiles0=.
SourceFiles1=resources

[SourceFiles0]
%FILE0%=
%FILE1%=

[SourceFiles1]
%FILE2%=
