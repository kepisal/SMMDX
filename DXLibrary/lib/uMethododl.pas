unit uMethododl;

interface

uses
  Windows, Messages, SysUtils, StrUtils, Variants, Classes, IniFiles, Math, IdHTTP, IdIOHandler,OleCtrls, SHDocVw,
  MSHTML, extctrls,Registry,ShellAPI,Seed,Forms;
  function FileVersion(const FileName:TFileName):String;
  function FileDecryption(const filename:String;key:String):String;
  function FileEncryption(const filename:String;key:String;source:String):String;
  procedure SetAutoStart_REG(AppName, AppTitle: string; bRegister: Boolean);
  procedure RemoveEntryFromRegistry(AppName:String);

implementation
// Pisal




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
