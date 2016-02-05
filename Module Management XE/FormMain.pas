unit FormMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.WinXCtrls, Vcl.ComCtrls, uMethod, System.IniFiles, MySeed, FormParam,
  mTypes, GetKHAversion, FormSetting, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient,
  IdSMTPBase, IdSMTP,Contnrs;

const
  wm_start = WM_USER + $1005;

type
  TMainForm = class(TForm)
    mmBar: TMainMenu;
    mniModule: TMenuItem;
    pnlWorkArea: TPanel;
    pnlTop: TPanel;
    pnlSearch: TPanel;
    pnlDate: TPanel;
    srchModule: TSearchBox;
    dtpFrom: TDateTimePicker;
    lblTo: TLabel;
    dtpTo: TDateTimePicker;
    btnStart: TButton;
    btnUpdate: TButton;
    lvModule: TListView;
    pnlinDateL: TPanel;
    pnlinDateR: TPanel;
    stat1: TStatusBar;
    trycn: TTrayIcon;
    pnlMainForm: TPanel;
    pnlModuelInfo: TPanel;
    pnlLModule: TPanel;
    pnlRModule: TPanel;
    pnlLTmodule: TPanel;
    pnlLBModule: TPanel;
    lvModuleInfo: TListView;
    srchModuleName: TSearchBox;
    pnlRTModule: TPanel;
    pnlRBModule: TPanel;
    grpMoudleInfo: TGroupBox;
    grdpnlModule: TGridPanel;
    lblName: TLabel;
    edtName: TEdit;
    lblType: TLabel;
    edtType: TEdit;
    lblService: TLabel;
    edtService: TEdit;
    lblCode: TLabel;
    edtCode: TEdit;
    lblParam: TLabel;
    edtParam: TEdit;
    pnlRBButton: TPanel;
    btnSave: TButton;
    btnDelete: TButton;
    Main: TMenuItem;
    Setting1: TMenuItem;
    Help1: TMenuItem;
    AboutUS1: TMenuItem;
    btnCount: TButton;
    { Panel Main Form Interface code }
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure InitComp();
    procedure lvModuleAdvancedCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure loadModuleToMainForm();

    procedure btnStartClick(Sender: TObject);

    procedure statusClicked();
    procedure addTest();
    procedure trycnClick(Sender: TObject);

    // Menu code Interface coding
    procedure MainClick(Sender: TObject);
    procedure New1Click(Sender: TObject);
    // End Menu code Interface coding

    { End Main Form Interface code }

    { Panel Module Infomation Interface code }
    procedure loadFiletoNewModuleInfo();
    procedure saveModule(Sender: TObject);
    procedure lvModuleInfoClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure edtParamClick(Sender: TObject);
    procedure mniModuleClick(Sender: TObject);
    procedure Setting1Click(Sender: TObject);
    procedure btnCountClick(Sender: TObject);

    { End Module infomation Interface code }
  private
    { Private declarations }
  public
    procedure _ExecuteAndWait(const aCommander: string);
    procedure _ExecMultiProcess(ProgramName: String; Wait: Boolean);

    procedure _wmReceiveData(var msg: TWMCopyData); message WM_COPYDATA;
    procedure _wmStart(var msg: TMessage); message wm_start;
  end;
var
  MainForm: TMainForm;

implementation

uses
  drawprogressU;
{ Object to use with multi thread }

type
   TMyThread = class(TThread)
    procedure Execute; override;
  end;
  TModule = class(TObject)
    index:integer;
    types:String;
    name:string;
    service:string;
    code:string;
    status:String;
    keycode:String;
    result:String;
    version:String;
  end;
  TExModuleList = class(TObjectList)
    protected
    procedure setModule(I:Integer; obj:TModule);
    function getModule(I:Integer):TModule;
    public
    property Module[I:Integer]:TModule read getModule write setModule;
  end;
  { Object to use with multi thread }
var
   ExModulelist:TExModuleList;
   ModuleList:TExModuleList; // ArrayList **************
{$R *.dfm}
{ Execute Module list ------> }
procedure TExModuleList.setModule(I: Integer; obj: TModule);
begin
  Items[I] := obj;
end;

function TExModuleList.getModule(I: Integer):TModule;
begin
  Result := TModule(Items[I]);
end;

{ End Execute Module list <--------- }

{ Panel Main Form code implementation -------> }
procedure TMainForm.FormCreate(Sender: TObject);
begin
  pnlModuelInfo.Visible := false;
  pnlMainForm.Visible := True;
  ExModulelist := TExModuleList.Create;
  ModuleList := TExModuleList.Create;

  // addTest;
  loadModuleToMainForm;
  loadFiletoNewModuleInfo;
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  InitComp;
end;

procedure TMainForm.InitComp;
var
  lvX: Integer;
begin
  lvX := lvModule.Width;
  lvModule.Columns[0].Width := Round((lvX * 3) / 100);
  lvModule.Columns[1].Width := Round((lvX * 12) / 100);
  lvModule.Columns[2].Width := Round((lvX * 12) / 100);
  lvModule.Columns[3].Width := Round((lvX * 12) / 100);
  lvModule.Columns[4].Width := Round((lvX * 12) / 100) - 1;
  lvModule.Columns[5].Width := Round((lvX * 25) / 100) - 2;
  lvModule.Columns[6].Width := Round((lvX * 12) / 100) - 2;
  lvModule.Columns[7].Width := Round((lvX * 12) / 100) - 2;
  lvModule.Refresh;
  lvX := lvModuleInfo.Width;
  lvModuleInfo.Columns[0].Width := Round((lvX * 19) / 100) - 4;
  lvModuleInfo.Columns[1].Width := Round((lvX * 40) / 100);
  lvModuleInfo.Columns[2].Width := Round((lvX * 40) / 100);
  lvModuleInfo.Refresh;

  if Self.Width > 900 then
  begin
    pnlRBButton.Margins.Bottom := 30;
    grpMoudleInfo.Margins.Bottom := 280;
  end
  else
  begin
    grpMoudleInfo.Margins.Bottom := 150;
    pnlRBButton.Margins.Bottom := 10;
  end;

end;

procedure TMainForm.lvModuleAdvancedCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
const
  ProgressBarCol = 5;
  Max = 100;
var
  Rct, PBRct: TRect;
  Percent: Integer;
  I: Integer;
begin
  if (SubItem = ProgressBarCol) and (Stage = cdPostPaint) then
  begin
    Percent := Integer(Item.Data);
    SetBkMode(Sender.Canvas.Handle, TRANSPARENT);

    Rct := Item.DisplayRect(drBounds);
    for I := 0 to SubItem - 1 do
    Rct.Left := Rct.Left + Sender.Column[I].Width;
    Rct.Right := Rct.Left + Sender.Column[SubItem].Width;
    // Sender.Canvas.TextOut(Rct.Left + 2, Rct.Top + 2, IntToStr(Percent) + '%');

    PBRct.Left := Rct.Left + Sender.Canvas.TextWidth('100') - 18;
    PBRct.Right := Rct.Right - 2;
    PBRct.Top := Rct.Top + 2;
    PBRct.Bottom := Rct.Bottom - 2;
    if PBRct.Right > PBRct.Left then
      if Percent <= Max then
      begin
        if (Percent = 0) then
        begin
          DrawProgress(Sender.Canvas, PBRct, Percent, Max, clLime, '',
            lvModule.Font);
        end
        else if (Percent > 0) And (Percent < Max) then
        begin
          DrawProgress(Sender.Canvas, PBRct, Percent, Max, clRed, 'Processing',
            lvModule.Font);
        end
        else if (Percent = Max) then
          DrawProgress(Sender.Canvas, PBRct, Percent, Max, clLime, 'completed',
            lvModule.Font);
      end;
  end

end;

procedure TMainForm.loadModuleToMainForm;
var
  dclInitFile: TIniFile;
  dclSection: TStringList;
  delimeter: string;
  dclI: Integer;
  dclParam: String;
  dclMName, dclMType, dclMService, dclMCode, dclMParam: string;
begin
  delimeter := '|';
  lvModule.Clear;
  if FileExists(ExtractFilePath(ParamStr(0)) + 'Logs\ModuleInfo.reg') then
  begin
    // dclInitFile := TIniFile.Create(ExtractFilePath(ParamStr(0) + 'Logs\ModuleInfo.reg'));
    dclInitFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) +
      'Logs\ModuleInfo.reg');
    dclSection := TStringList.Create;
    dclInitFile.ReadSections(dclSection);
    for dclI := 0 to dclSection.Count - 1 do
    begin
      dclParam := dclInitFile.ReadString('Module' + IntToStr(dclI),
        'ModuleInfo', '');
      dclParam := seedDcpFromSHA256('ModuleInfo', dclParam);
      dclMName := StrGrab(dclParam, delimeter, delimeter, 1);
      dclMType := StrGrab(dclParam, delimeter, delimeter, 2);
      dclMService := StrGrab(dclParam, delimeter, delimeter, 3);
      dclMCode := StrGrab(dclParam, delimeter, delimeter, 4);
      dclMParam := StrGrab(dclParam, delimeter, delimeter, 5);
      // adding module information to lvModuleInfo
      with lvModule.Items.Add do
      begin
        Caption := IntToStr(dclI + 1);
        SubItems.Add(dclMName);
        SubItems.Add(dclMType);
        SubItems.Add(dclMService);
        SubItems.Add(dclMCode);
        SubItems.Add(dclMParam);
        SubItems.Add('');
        SubItems.Add('');
      end;

    end;
  end
  else
    ShowMessage('File is not exsit...!');
  stat1.Panels[1].Text := IntToStr(lvModule.Items.Count);
end;

procedure TMainForm.statusClicked;
const
  statusLeft = 76;
  statusRight = 88;
var
  pt: TPoint;
  lvX, pos: Integer;
begin
  pt := lvModule.ScreenToClient(Mouse.CursorPos);
  lvX := lvModule.Width;
  pos := Round((pt.X * 100) / lvX);
  if (pos > statusLeft) and (pos < statusRight) then
    ShowMessage(Format('Pixel x : %d%', [pos]));

end;

// Menu code implementation
procedure TMainForm.MainClick(Sender: TObject);
begin
  pnlMainForm.Visible := True;
  pnlModuelInfo.Visible := false;
  InitComp;
  loadModuleToMainForm;
end;

procedure TMainForm.New1Click(Sender: TObject);
begin
  pnlMainForm.Visible := false;
  pnlModuelInfo.Visible := True;
  InitComp;
  loadFiletoNewModuleInfo;
end;
// End Menu code implementation
{ End Panel Main Form code implementaion <------- }

{ Module Management Code block -------> }
procedure TMainForm._ExecuteAndWait(const aCommander: string);
var
  tmpStartupInfo: TStartupInfo;
  tmpProcessInformation: TProcessInformation;
  tmpProgram: string;
begin
  tmpProgram := Trim(aCommander);
  FillChar(tmpStartupInfo, SizeOf(tmpStartupInfo), 0);
  with tmpStartupInfo do
  begin
    cb := SizeOf(TStartupInfo);
    wShowWindow := SW_HIDE;
  end;
  // ShowMessage('1');
  if CreateProcess(nil, pchar(tmpProgram), nil, nil, True, CREATE_NO_WINDOW,
    nil, nil, tmpStartupInfo, tmpProcessInformation) then
  begin
    // loop every 10 ms
    while WaitForSingleObject(tmpProcessInformation.hProcess, 10) > 0 do
    begin
      Application.ProcessMessages;
    end;
    CloseHandle(tmpProcessInformation.hProcess);
    CloseHandle(tmpProcessInformation.hThread);
  end
  else
  begin
    RaiseLastOSError;
  end;

end;

procedure TMainForm._ExecMultiProcess(ProgramName: String; Wait: Boolean);
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CreateOK: Boolean;
  ProcID : Integer;
begin
  { fill with known state }
  FillChar(StartInfo, SizeOf(TStartupInfo), #0);
  FillChar(ProcInfo, SizeOf(TProcessInformation), #0);
  StartInfo.cb := SizeOf(TStartupInfo);
  CreateOK := CreateProcess(nil, pchar(ProgramName), nil, nil, false,
    CREATE_NEW_PROCESS_GROUP + NORMAL_PRIORITY_CLASS, nil, nil, StartInfo,
    ProcInfo);
  { check to see if successful }
  if CreateOK then
  begin
    // may or may not be needed. Usually wait for child processes
    if Wait then
      WaitForSingleObject(ProcInfo.hProcess, INFINITE);
  end
  else
  begin
    ShowMessage('Unable to run ' + ProgramName);
  end;
  CloseHandle(ProcInfo.hProcess);
  CloseHandle(ProcInfo.hThread);
end;

procedure TMainForm._wmReceiveData(var msg: TWMCopyData);
var
  dclDataStr: String;
  progress: Integer;
  dclSMName: String;
  dclSMStatus: string;
  dclSMThread:String;
  dclSMProcess: String;
  I: Integer;
  dclI: Integer;
begin
  dclDataStr := pchar(msg.CopyDataStruct.lpData);
  dclSMName := Trim(StrGrab(dclDataStr, '[', ':'));
  dclSMStatus := Trim(StrGrab(dclDataStr, ':', ']'));
  dclSMProcess := Trim(StrGrab(dclDataStr, '(', ')'));
  dclSMThread := Trim(StrGrab(dclDataStr,'*','*'));
  if not SameText(dclSMProcess, '') then
    progress := StrToInt(dclSMProcess)
  else
    progress := 0;

  for I := 0 to lvModule.Items.Count - 1 do
  begin
    with lvModule.Items.Item[I] do
    begin
      if SameText(dclSMName, SubItems[3]) then
      begin
        dclI := I;
        SubItems[5] := dclSMStatus;
        Data := Pointer(progress);
      end;
    end;
    lvModule.Refresh;
  end;

  for I := 0 to ExModulelist.Count - 1 do
    begin
      if SameText(dclSMName,ExModulelist.getModule(i).name) then
      begin
        ExModulelist.getModule(i).status := dclSMThread;
      end;
    end;

  for I := 0 to ModuleList.Count - 1 do
    begin
      if SameText(dclSMName,ModuleList.getModule(i).name) then
      begin
        ModuleList.getModule(i).status := dclSMStatus;
      end;
    end;

  if pos(M_SDT_RESULT, dclDataStr) <> 0 then
     begin
     //ShowMessage(dclDataStr);
     for I := 0 to ModuleList.Count - 1 do
    begin
      if SameText(dclSMName,ModuleList.getModule(i).name) then
      begin
        ModuleList.getModule(i).result := dclSMStatus;
      end;
    end;

     end;
  if pos(M_SDT_STATUS, dclDataStr) <> 0 then
       //ShowMessage(dclDataStr);
      begin
        for I := 0 to ModuleList.Count - 1 do
    begin
      if SameText(dclSMName,ModuleList.getModule(i).name) then
      begin
        ModuleList.getModule(i).status := dclSMStatus;
      end;
    end;

      end;
  if pos(M_SDT_ERROR, dclDataStr) <> 0 then
       //ShowMessage(dclDataStr);
  begin
    for I := 0 to ModuleList.Count - 1 do
    begin
      if SameText(dclSMName,ModuleList.getModule(i).name) then
      begin
        ModuleList.getModule(i).keycode := dclSMStatus;
      end;
    end;
  end;

end;

procedure TMainForm._wmStart(var msg: TMessage);
var
  MyThread: TMyThread;
begin
  MyThread := TMyThread.Create(True);
  MyThread.FreeOnTerminate := True;
  MyThread.Start;
end;
{ End Module Management Code block <------- }

{ Panel Module Infomation code implementation -------> }
procedure TMainForm.loadFiletoNewModuleInfo;
var
  dclInitFile: TIniFile;
  dclSection: TStringList;
  dclI, I: Integer;
  dclMName, dclMType: String;
  dclParam, delimeter: String;
begin
  lvModuleInfo.Clear;
  delimeter := '|';

  // Clear all Textedit control
  for I := 0 to grdpnlModule.ControlCount - 1 do
    if grdpnlModule.Controls[I] is TEdit then
    begin
      (grdpnlModule.Controls[I] as TEdit).Clear;
    end;
  // Disable btnDelete
  btnDelete.Enabled := false;
  // Checking file ModuleInfo.reg exist...
  if FileExists(ExtractFilePath(ParamStr(0)) + 'Logs\ModuleInfo.reg') then
  begin
    // dclInitFile := TIniFile.Create(ExtractFilePath(ParamStr(0) + 'Logs\ModuleInfo.reg'));
    dclInitFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) +
      'Logs\ModuleInfo.reg');
    dclSection := TStringList.Create;
    dclInitFile.ReadSections(dclSection);
    for dclI := 0 to dclSection.Count - 1 do
    begin
      dclParam := dclInitFile.ReadString('Module' + IntToStr(dclI),
        'ModuleInfo', '');
      dclParam := seedDcpFromSHA256('ModuleInfo', dclParam);
      dclMName := StrGrab(dclParam, delimeter, delimeter, 1);
      dclMType := StrGrab(dclParam, delimeter, delimeter, 2);

      // adding module information to lvModuleInfo
      with lvModuleInfo.Items.Add do
      begin
        Caption := IntToStr(dclI + 1);
        SubItems.Add(dclMName);
        SubItems.Add(dclMType);
      end;

    end;
  end
  else
    ShowMessage('File is not exsit...!')
end;

procedure TMainForm.saveModule(Sender: TObject);
var
  dclBInfo: String;
  dclParam: String;
  dclSection: TStringList;
  dclLastSection: String;
  delimeter: String;
  dclIniFile: TIniFile;
  I: Integer;
begin
  // Check folder is exist
  if not DirectoryExists(ExtractFilePath(ParamStr(0) + 'Logs\')) then
  // ParamStr(0) return Current Working Directory
    CreateDir(ExtractFilePath(ParamStr(0)) + 'Logs\');

  // Encrypt all module information
  delimeter := '|';
  dclBInfo := delimeter + edtName.Text + delimeter + edtType.Text + delimeter +
    edtService.Text + delimeter + edtCode.Text + delimeter + edtParam.Text +
    delimeter;
  dclParam := SeedEncToSHA256('ModuleInfo', dclBInfo);

  // Checking ModuleInfo.reg file is exist...
  if FileExists(ExtractFilePath(ParamStr(0)) + 'Logs\ModuleInfo.reg') then
  begin
    dclIniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) +
      'Logs\ModuleInfo.reg');
    dclSection := TStringList.Create;
    dclIniFile.ReadSections(dclSection);
    // Saving Module Infomation
    if SameText('Save', btnSave.Caption) then
    begin
      dclLastSection := IntToStr(dclSection.Count);
      dclIniFile.WriteString('Module' + dclLastSection, 'Module_Name',
        Trim(edtName.Text));
      dclIniFile.WriteString('Module' + dclLastSection, 'ModuleInfo', dclParam);
      dclIniFile.UpdateFile;
      ShowMessage('Insert Completed!');
    end
    else if SameText('Update', btnSave.Caption) then
    begin
      I := lvModuleInfo.Selected.Index;
      dclLastSection := IntToStr(I);
      dclIniFile.WriteString('Module' + dclLastSection, 'Module_Name',
        Trim(edtName.Text));
      dclIniFile.WriteString('Module' + dclLastSection, 'ModuleInfo', dclParam);
      dclIniFile.UpdateFile;
      ShowMessage('Update Completed!');
      btnSave.Caption := 'Save';
    end;
  end

  // First Inserting to ModuleInfo.reg
  else
  begin
    dclIniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) +
      'Logs\ModuleInfo.reg');
    dclIniFile.WriteString('Module0', 'Module_Name', Trim(edtName.Text));
    dclIniFile.WriteString('Module0', 'ModuleInfo', dclParam);
    ShowMessage('Insert Completed!');
  end;

  // Reloading data in lvModuleInfo
  loadFiletoNewModuleInfo;
end;

procedure TMainForm.Setting1Click(Sender: TObject);
var
  settingForm: TSetting;
begin
  settingForm := TSetting.Create(nil);
  settingForm.Show;
end;

procedure TMainForm.btnCountClick(Sender: TObject);
var
  mResult : String;
  i:Integer;
begin
  for i:= 0 to ModuleList.Count - 1 do
  begin
    with ModuleList.getModule(i) do
    begin
      mResult := 'Name : ' + name + #13#10
               + 'Type : ' + types+ #13#10
               + 'Service : ' + service + #13#10
               + 'status : ' + status + #13#10
               + 'Keycode : ' + keycode + #13#10
               + 'Version : ' + version + #13#10
               + 'Result : ' + result ;
    end;
    ShowMessage(mResult);
  end;

end;

procedure TMainForm.btnDeleteClick(Sender: TObject);
var
  dclBInfo, dclFilePath: String;
  dclMName, dclParam: String;
  dclSection: TStringList;
  dclLastSection: String;
  delimeter: String;
  dclIniFile: TIniFile;
  I: Integer;
begin
  dclFilePath := ExtractFilePath(ParamStr(0)) + 'Logs\ModuleInfo.reg';
  delimeter := '|';
  if FileExists(dclFilePath) then
    dclIniFile := TIniFile.Create(dclFilePath);
  dclSection := TStringList.Create;
  dclIniFile.ReadSections(dclSection);
  I := lvModuleInfo.Selected.Index;
  dclLastSection := IntToStr(I);
  if I = dclSection.Count - 1 then
    dclIniFile.EraseSection('Module' + IntToStr(I))
  else
  begin
    for I := I to dclSection.Count - 1 do
    begin
      if (I + 1) = (dclSection.Count) then
      begin
        dclIniFile.EraseSection('Module' + IntToStr(I));
        ShowMessage('Delete Completed!');
        loadFiletoNewModuleInfo;
        Exit;
      end
      else
      begin
        dclMName := dclIniFile.ReadString('Module' + IntToStr(I + 1),
          'Module_Name', '');
        dclParam := dclIniFile.ReadString('Module' + IntToStr(I + 1),
          'ModuleInfo', '');
        dclLastSection := IntToStr(I);
        dclIniFile.WriteString('Module' + dclLastSection, 'Module_Name',
          dclMName);
        dclIniFile.WriteString('Module' + dclLastSection, 'ModuleInfo',
          dclParam);
        dclIniFile.UpdateFile;
      end;
    end;
  end;
  dclIniFile.UpdateFile;
  loadFiletoNewModuleInfo;
  if SameText('Update', btnSave.Caption) then
    btnSave.Caption := 'Save';
  ShowMessage('Delete Completed!');
end;

procedure TMainForm.lvModuleInfoClick(Sender: TObject);
var
  dclRMName, dclRMType, dclFMName, dclFMType: string;
  dclIniFile: TIniFile;
  dclSection: TStringList;
  Index: Integer;
  dclFilePath: string;
  dclI: Integer;
  dclParam: String;
  delimeter: string;
begin
  if lvModuleInfo.Selected <> nil then
  begin
    index := lvModuleInfo.Selected.Index;
    with lvModuleInfo.Items do
    begin
      dclRMName := Item[index].SubItems.Strings[0];
      dclRMType := Item[index].SubItems.Strings[1];
    end;
    dclFilePath := ExtractFilePath(ParamStr(0)) + 'Logs\ModuleInfo.reg';
    delimeter := '|';
    if FileExists(dclFilePath) then
      dclIniFile := TIniFile.Create(dclFilePath);
    dclSection := TStringList.Create;
    dclIniFile.ReadSections(dclSection);
    for dclI := 0 to dclSection.Count - 1 do
    begin
      dclFMName := dclIniFile.ReadString('Module' + IntToStr(dclI),
        'Module_Name', '');
      if (SameText(dclFMName, dclRMName)) then
      begin
        dclParam := dclIniFile.ReadString('Module' + IntToStr(dclI),
          'ModuleInfo', '');
        dclParam := seedDcpFromSHA256('ModuleInfo', dclParam);
        // set text from file to edit
        edtName.Text := StrGrab(dclParam, delimeter, delimeter, 1);
        edtType.Text := StrGrab(dclParam, delimeter, delimeter, 2);
        edtService.Text := StrGrab(dclParam, delimeter, delimeter, 3);
        edtCode.Text := StrGrab(dclParam, delimeter, delimeter, 4);
        edtParam.Text := StrGrab(dclParam, delimeter, delimeter, 5);
      end;
    end;
    btnSave.Caption := 'Update';
    btnDelete.Enabled := True;
  end;
end;

procedure TMainForm.edtParamClick(Sender: TObject);
var
  clsParam: TParam;
begin
  clsParam := TParam.Create(nil);
  edtParam.Text := clsParam.GetParam(edtParam.Text);
  FreeAndNil(clsParam);
end;

{ End Panel Module Infomation code implementaion  <-------- }
procedure TMainForm.btnStartClick(Sender: TObject);
var
  i:Integer;
begin
  SendMessage(Self.Handle, wm_start, 0, 0);
  i := ExModulelist.Count;
end;

procedure TMainForm.mniModuleClick(Sender: TObject);
begin
  pnlMainForm.Visible := false;
  pnlModuelInfo.Visible := True;
  loadFiletoNewModuleInfo;
end;

{ Multi Processing Implementation code block }
procedure TMyThread.Execute;
var
  count:Integer;
  aParam,mExecute:string;
  remain_module:Integer;
  Tnum,i,j,k : Integer;
  isCheck:Boolean;
  indx: Array of Integer;
  mPath,extension:String;
  terminated:String;
  Module:TModule;
begin
  mPath := '../module/';
  extension:='.kha';
  isCheck := false;
  ModuleList.Clear;
  Try
     count := 0;
    // count all module that has checked to run
    for i := 0 to MainForm.lvModule.Items.Count - 1 do
      begin
        if MainForm.lvModule.Items[i].Checked then
        begin
           Inc(count);
        end;
      end;

    // Get index of module has been check
    SetLength(indx,count);
    j := 0;
    for i := 0 to MainForm.lvModule.Items.Count - 1 do
      begin
        if MainForm.lvModule.Items[i].Checked then
        begin
          indx[j] := MainForm.lvModule.Items[i].Index;
          inc(j);
          // Add Module to ModuleList
          Module := TModule.Create;
          Module.index := MainForm.lvModule.Items[i].Index;
          Module.types := MainForm.lvModule.Items[i].SubItems[0];
          Module.name  := MainForm.lvModule.Items[i].SubItems[3];
          Module.service := MainForm.lvModule.Items[i].SubItems[2];
          Module.code := '';
          Module.status := MainForm.lvModule.Items[i].SubItems[5];
          Module.keycode := '';
          Module.result := '';
          Module.version := _GetKHAFileData(mPath + MainForm.lvModule.Items[i].SubItems[3] + extension).FileVersion;
          ModuleList.Add(Module);
          isCheck := true;
        end;
      end;

    j := 0;
    // Access listview items with indx's value
    remain_module := count;
    Tnum :=  2; // Thread Numbers process
    if isCheck = true then
    begin
      repeat
      if remain_module <= Tnum then
      begin

          for i := 0 to remain_module - 1 do
            begin
              // implementation code blocks
              aParam := MainForm.lvModule.Items.Item[indx[j]].SubItems[4];
              aParam := seedDcpFromSHA256('mParam', aParam);
              aParam := StringReplace(aParam, '[DTP-START]',
                        FormatDateTime('yyyymmdd', MainForm.dtpFrom.DateTime),
                        [rfReplaceAll, rfIgnoreCase]);
              aParam := StringReplace(aParam, '[DTP-END]',
                        FormatDateTime('yyyymmdd',MainForm.dtpTo.DateTime),
                        [rfReplaceAll, rfIgnoreCase]);

              mExecute := mPath
                        + MainForm.lvModule.Items.Item[indx[j]].SubItems[3]
                        + extension;
              if FileExists(mExecute) then
              begin
                MainForm.lvModule.Items.Item[indx[j]].SubItems[6] := _GetKHAFileData(mExecute).FileVersion;
                mExecute := mExecute + ' "' + aParam + '"';
                MainForm._ExecMultiProcess(mExecute,false);
              end;
              Inc(j);
            end;
         remain_module := 0;
      end
      else
        if remain_module > Tnum then
        begin
          for i := 0 to Tnum - 1 do
            begin
              // implementation code blocks
              aParam := MainForm.lvModule.Items.Item[indx[j]].SubItems[4];
              aParam := seedDcpFromSHA256('mParam', aParam);
              aParam := StringReplace(aParam, '[DTP-START]',
                        FormatDateTime('yyyymmdd', MainForm.dtpFrom.DateTime),
                        [rfReplaceAll, rfIgnoreCase]);
              aParam := StringReplace(aParam, '[DTP-END]',
                        FormatDateTime('yyyymmdd',MainForm.dtpTo.DateTime),
                        [rfReplaceAll, rfIgnoreCase]);

              mExecute := mPath
                        + MainForm.lvModule.Items.Item[indx[j]].SubItems[3]
                        + extension;
              if FileExists(mExecute) then
              begin
                MainForm.lvModule.Items.Item[indx[j]].SubItems[6] := _GetKHAFileData(mExecute).FileVersion;
                mExecute := mExecute + ' "' + aParam + '"';
                MainForm._ExecMultiProcess(mExecute,false);
              end;

              Module := TModule.Create;
              Module.name := MainForm.lvModule.Items.Item[indx[j]].SubItems[3];
              Module.status := 'Running';
              ExModulelist.Add(Module);
              Inc(j);
            end;

          // Check Module Terminated
          terminated := 'False';
          repeat
            Sleep(300);
            Application.ProcessMessages;
            for k := 0 to ExModulelist.Count - 1 do
              begin
                if SameText(ExModulelist.getModule(k).status,'Terminated') then
                begin
                  terminated := 'True';
                end
                else
                  if SameText(ExModulelist.getModule(k).status,'Running') then
                  begin
                    terminated := 'False';
                  end;
              end;
          until terminated = 'True' ;
          ExModulelist.Clear;
          remain_module := remain_module - Tnum;
        end;
     until remain_module = 0 ;

  end;
 except
    ShowMessage('Start Error...');
 end;
 if not isCheck then
   MessageBox(0, pchar('Please choose the module that you want to run!'), '',
      MB_OK + MB_ICONINFORMATION);
end;

{ End mulit Processing Implementation code block }

procedure TMainForm.trycnClick(Sender: TObject);
begin
  Self.Visible := True;
end;

procedure TMainForm.addTest;
var
  I, Items: Integer;
begin
  Items := 2;
  for I := 0 to Items - 1 do
    with lvModule.Items.Add do
    begin

      SubItems.Add(Format('Type %d', [I]));
      SubItems.Add(Format('Name %d', [I]));
      SubItems.Add(Format('Service %d', [I]));
      SubItems.Add(Format('code %d', [I]));
      SubItems.Add('');
      SubItems.Add(Format('status %d', [I]));
      SubItems.Add(Format('version %d', [I]));
      Data := Pointer(0);
    end;
end;

end.
