; SKAPP Windows kurulumcu (Inno Setup) — imzasız beta.
; Derle:  iscc /DAppVersion=0.4.0 /O<cikti-klasoru> skapp.iss
; AppVersion CI/script tarafından geçilir; yoksa aşağıdaki varsayılan kullanılır.

#ifndef AppVersion
  #define AppVersion "0.4.0"
#endif
#define AppName "SKAPP"
#define AppPublisher "SmartKraft"
#define AppExeName "skapp.exe"
; flutter build windows --release çıktısı (bu .iss'e göreli):
#define BuildDir "..\..\build\windows\x64\runner\Release"

[Setup]
AppId={{A3F2C1B4-7D8E-4F1A-9B2C-3E4D5A6B7C8E}}
AppName={#AppName}
AppVersion={#AppVersion}
AppPublisher={#AppPublisher}
DefaultDirName={autopf}\{#AppName}
DefaultGroupName={#AppName}
UninstallDisplayIcon={app}\{#AppExeName}
OutputBaseFilename=SKAPP-windows-setup
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "tr"; MessagesFile: "compiler:Languages\Turkish.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#BuildDir}\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs

[Icons]
Name: "{group}\{#AppName}"; Filename: "{app}\{#AppExeName}"
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#AppExeName}"; Description: "{cm:LaunchProgram,{#AppName}}"; Flags: nowait postinstall skipifsilent
