unit uUtilitise;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants,
  Classes, IniFiles, Math, IdHTTP, IdIOHandler,OleCtrls, SHDocVw,graphics,
  MSHTML, extctrls,Registry,ShellAPI,Seed,Forms,Controls,
  Dialogs, StdCtrls, ComCtrls, Menus, mTypes, Grids, ValEdit;


  function FileVersion(const FileName:TFileName):String;
  function FileDecryption(const filename:String;key:String):String;
  function FileEncryption(const filename:String;key:String;source:String):String;
  procedure CreateFile(const filename:String;source:String);
  procedure SetAutoStart_REG(AppName, AppTitle: string; bRegister: Boolean);
  procedure RemoveEntryFromRegistry(AppName:String);
  procedure DialogBoxAutoClose(const ACaption, APrompt: string; DuracaoEmSegundos: Integer;AppClose:Boolean);

implementation
// Pisal

procedure DialogBoxAutoClose(const ACaption, APrompt: string; DuracaoEmSegundos: Integer;AppClose:Boolean);
var
  Form: TForm;
  Prompt: TLabel;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  nX, Lines: Integer;

  function GetAveCharSize(Canvas: TCanvas): TPoint;
    var
      I: Integer;
      Buffer: array[0..51] of Char;
    begin
      for I := 0 to 25 do Buffer[I]          := Chr(I + Ord('A'));
      for I := 0 to 25 do Buffer[I + 26]    := Chr(I + Ord('a'));
      GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
      Result.X := Result.X div 52;
    end;

begin
  Form       := TForm.Create(Application);
  Lines   := 0;

  For nX := 1 to Length(APrompt) do
     if APrompt[nX]=#13 then Inc(Lines);

  with Form do
    try
      Font.Name:='Arial';     //mcg
      Font.Size:=10;          //mcg
      Font.Style:=[fsBold];
      Canvas.Font    := Font;
      DialogUnits    := GetAveCharSize(Canvas);
      //BorderStyle    := bsDialog;
      BorderStyle    := bsToolWindow;
      FormStyle         := fsStayOnTop;
      BorderIcons      := [];
      Caption          := ACaption;
      ClientWidth    := MulDiv(Screen.Width div 4, DialogUnits.X, 4);
      ClientHeight    := MulDiv(23 + (Lines*10), DialogUnits.Y, 8);
      Position          := poScreenCenter;

      Prompt             := TLabel.Create(Form);
      with Prompt do
      begin
        Parent          := Form;
        AutoSize       := True;
        Left             := MulDiv(8, DialogUnits.X, 4);
        Top             := MulDiv(8, DialogUnits.Y, 8);
        Caption       := APrompt;
      end;

      Form.Width:=Prompt.Width+Prompt.Left+50;  //mcg fix

      Show;
      Application.ProcessMessages;
      if AppClose= true then
      Application.Terminate;
    finally
       Sleep(DuracaoEmSegundos*1000);
      Form.Free;
    end;
end;


procedure RemoveEntryFromRegistry(AppName:String);
var key: string;
     Reg: TRegIniFile;
begin
  key := '\Software\Microsoft\Windows\CurrentVersion\Run';
  Reg:=TRegIniFile.Create;
try
  Reg.RootKey:=HKey_Local_Machine;
  if Reg.OpenKey(Key,False) then Reg.DeleteValue(AppName);
  finally
  Reg.Free;
  end;
end;

procedure SetAutoStart_REG(AppName, AppTitle: string; bRegister: Boolean);
const
  RegKey = '\Software\Microsoft\Windows\CurrentVersion\Run';
  // or: RegKey = '\Software\Microsoft\Windows\CurrentVersion\RunOnce';
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    if Registry.OpenKey(RegKey, False) then
    begin
      if bRegister = False then
        Registry.DeleteValue(AppTitle)
      else
        Registry.WriteString(AppTitle, AppName);
    end;
  finally
    Registry.Free;
  end;
end;
procedure CreateFile(const filename:String;source:String);
var
  F: TextFile;
begin
 AssignFile(F, filename);
  ReWrite(F);
  Write(F, source);
  //Write(F, source);
  CloseFile(F)
end;

function FileDecryption(const filename:String;key:String):String;
var
  text, temp,fullFileName,fileini: string;
  F: TextFile;
begin
  if FileExists(filename) then
  begin
     AssignFile(F, filename);
  // Reopen the file for reading
  Reset(F);

  // Display the file contents
  while not Eof(F) do
  begin
    ReadLn(F, text);
    temp := temp + text;
  end;
  // Close the file for the last time
  CloseFile(F);
  Result := SeedDecFromBase64(key, temp);
  end else Result:='NAN';
end;
function FileEncryption(const filename:String;key:String;source:String):String;
var
  textString: string;
  F: TextFile;
begin
  AssignFile(F, filename);
  ReWrite(F);
  textString := SeedEncToBase64(key, source);
  Write(F, textString);
  //Write(F, source);
  CloseFile(F);
  Result := 'Success';
end;
function FileVersion(const FileName: TFileName): String;
var
  VerInfoSize: Cardinal;
  VerValueSize: Cardinal;
  Dummy: Cardinal;
  PVerInfo: Pointer;
  PVerValue: PVSFixedFileInfo;
begin
  Result := 'null';
  VerInfoSize := GetFileVersionInfoSize(PChar(FileName), Dummy);
  GetMem(PVerInfo, VerInfoSize);
  try
    if GetFileVersionInfo(PChar(FileName), 0, VerInfoSize, PVerInfo) then
      if VerQueryValue(PVerInfo, '\', Pointer(PVerValue), VerValueSize) then
        with PVerValue^ do
          Result := Format('v%d.%d.%d build %d', [
            HiWord(dwFileVersionMS), //Major
            LoWord(dwFileVersionMS), //Minor
            HiWord(dwFileVersionLS), //Release
            LoWord(dwFileVersionLS)]); //Build
  finally
    FreeMem(PVerInfo, VerInfoSize);
  end;
end;

end.
