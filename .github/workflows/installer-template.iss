#define MyAppName "VxKex"
#define MyAppVersion "VERSION_PLACEHOLDER"
#define MyAppPublisher "VXsoft"
#define MyAppURL "https://github.com/i486/VxKex"
#define MyAppExeName "KexCfg.exe"

[Setup]
AppId={{8BC9CEB8-8B4A-11D0-8D11-00A0C91BC942}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}/issues
AppUpdatesURL={#MyAppURL}/releases
DefaultDirName={autopf}\VxKex
DefaultGroupName=VxKex
AllowNoIcons=yes
OutputDir=.
OutputBaseFilename=VxKex-{#MyAppVersion}-Setup
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin
MinVersion=6.1sp1

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "chinesesimplified"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "PackageRoot\x64\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: Is64BitInstallMode
Source: "PackageRoot\x86\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Check: not Is64BitInstallMode
Source: "PackageRoot\*.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "PackageRoot\*.txt"; DestDir: "{app}\Documentation"; Flags: ignoreversion recursesubdirs

[Icons]
Name: "{group}\VxKex Configuration"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\VxKex Documentation"; Filename: "{app}\Documentation"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\VxKex"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
const
  IFEO_BASE_KEY = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options';
  FLG_APPLICATION_VERIFIER = $00000100;
  VERIFIER_FLAGS = $80000000;

function GenerateRandomSubkeyName: String;
var
  Rand1, Rand2: Integer;
begin
  Rand1 := Random($FFFFFFFF);
  Rand2 := Random($FFFFFFFF);
  Result := Format('VxKex_%08X%08X', [Rand1, Rand2]);
end;

function ExtractFileNameOnly(const FullPath: String): String;
var
  P: Integer;
begin
  P := Length(FullPath);
  while (P > 0) and not (FullPath[P] in ['\', '/']) do
    Dec(P);
  Result := Copy(FullPath, P + 1, MaxInt);
end;

function FindClashVergeInstallPath: String;
var
  InstallPath: String;
  DefaultPath: String;
begin
  Result := '';

  if RegQueryStringValue(HKLM64, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Clash Verge', 'InstallLocation', InstallPath) then
  begin
    if DirExists(InstallPath) then
    begin
      Result := InstallPath;
      Exit;
    end;
  end;

  if RegQueryStringValue(HKLM32, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Clash Verge', 'InstallLocation', InstallPath) then
  begin
    if DirExists(InstallPath) then
    begin
      Result := InstallPath;
      Exit;
    end;
  end;

  if RegQueryStringValue(HKCU, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Clash Verge', 'InstallLocation', InstallPath) then
  begin
    if DirExists(InstallPath) then
    begin
      Result := InstallPath;
      Exit;
    end;
  end;

  DefaultPath := ExpandConstant('{localappdata}\Programs\Clash Verge');
  if DirExists(DefaultPath) then
  begin
    Result := DefaultPath;
    Exit;
  end;

  DefaultPath := ExpandConstant('{pf}\Clash Verge');
  if DirExists(DefaultPath) then
  begin
    Result := DefaultPath;
    Exit;
  end;

  DefaultPath := ExpandConstant('{pf32}\Clash Verge');
  if DirExists(DefaultPath) then
  begin
    Result := DefaultPath;
    Exit;
  end;
end;

function ConfigureVxKexForExe(const ExeFullPath: String; DisableForChild: Boolean): Boolean;
var
  ExeBaseName: String;
  SubkeyName: String;
  IfeoExeKeyPath: String;
  IfeoSubkeyPath: String;
begin
  Result := False;

  if not FileExists(ExeFullPath) then
  begin
    Log('File not found: ' + ExeFullPath);
    Exit;
  end;

  ExeBaseName := ExtractFileNameOnly(ExeFullPath);
  if ExeBaseName = '' then Exit;

  SubkeyName := GenerateRandomSubkeyName;
  IfeoExeKeyPath := IFEO_BASE_KEY + '\' + ExeBaseName;
  IfeoSubkeyPath := IfeoExeKeyPath + '\' + SubkeyName;

  Log('Configuring VxKex for: ' + ExeBaseName);

  try
    if not RegWriteDWordValue(HKLM64, IfeoExeKeyPath, 'UseFilter', 1) then Exit;
    if not RegWriteStringValue(HKLM64, IfeoSubkeyPath, 'FilterFullPath', ExeFullPath) then Exit;
    if not RegWriteStringValue(HKLM64, IfeoSubkeyPath, 'VerifierDlls', 'kexdll.dll') then Exit;
    if not RegWriteDWordValue(HKLM64, IfeoSubkeyPath, 'GlobalFlag', FLG_APPLICATION_VERIFIER) then Exit;
    if not RegWriteDWordValue(HKLM64, IfeoSubkeyPath, 'VerifierFlags', VERIFIER_FLAGS) then Exit;
    if not RegWriteDWordValue(HKLM64, IfeoSubkeyPath, 'KEX_DisableForChild', Ord(DisableForChild)) then Exit;
    if not RegWriteDWordValue(HKLM64, IfeoSubkeyPath, 'KEX_DisableAppSpecific', 0) then Exit;
    if not RegWriteDWordValue(HKLM64, IfeoSubkeyPath, 'KEX_WinVerSpoof', 0) then Exit;
    if not RegWriteDWordValue(HKLM64, IfeoSubkeyPath, 'KEX_StrongVersionSpoof', 0) then Exit;

    Log('Successfully configured: ' + ExeBaseName);
    Result := True;
  except
    Log('Error configuring: ' + ExeBaseName);
    Result := False;
  end;
end;

procedure AutoConfigureClashVerge;
var
  ClashVergePath: String;
  ExeList: array[0..3] of String;
  ExeFullPath: String;
  I: Integer;
  SuccessCount: Integer;
begin
  Log('Auto-configuring Clash Verge for VxKex...');

  Randomize;
  ClashVergePath := FindClashVergeInstallPath;

  if ClashVergePath = '' then
  begin
    Log('Clash Verge not found, skipping auto-configuration');
    Exit;
  end;

  Log('Found Clash Verge at: ' + ClashVergePath);

  if Copy(ClashVergePath, Length(ClashVergePath), 1) <> '\' then
    ClashVergePath := ClashVergePath + '\';

  ExeList[0] := 'Clash Verge.exe';
  ExeList[1] := 'resources\clash-verge-service.exe';
  ExeList[2] := 'resources\install-service.exe';
  ExeList[3] := 'resources\uninstall-service.exe';

  SuccessCount := 0;
  for I := 0 to 3 do
  begin
    ExeFullPath := ClashVergePath + ExeList[I];
    if ConfigureVxKexForExe(ExeFullPath, True) then
      SuccessCount := SuccessCount + 1;
  end;

  Log('Clash Verge auto-configuration completed: ' + IntToStr(SuccessCount) + '/4');
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    Sleep(1000);
    AutoConfigureClashVerge;
  end;
end;
