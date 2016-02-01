unit FormSetting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.CheckLst, System.Actions, Vcl.ActnList, Vcl.WinXCtrls;

type
  TSetting = class(TForm)
    ctgrypnlgrpSetting: TCategoryPanelGroup;
    ctgrypnlGeneral: TCategoryPanel;
    ctgrypnl2: TCategoryPanel;
    pnlRSetting: TPanel;
    pnlASchedule: TPanel;
    pnlASTop: TPanel;
    pnlASButtom: TPanel;
    grpAStop: TGroupBox;
    lblBegintask: TLabel;
    cbbtaskType: TComboBox;
    lblStart: TLabel;
    dtpSStartDate: TDateTimePicker;
    dtpSTime: TDateTimePicker;
    rgChoose: TRadioGroup;
    chklstDays: TCheckListBox;
    lblMailTo: TLabel;
    edtadminMail: TEdit;
    btnRemove: TButton;
    btnOk: TButton;
    btnCancle: TButton;
    mmoMailBody: TMemo;
    tvTaskManager: TTreeView;
    tvGeneral: TTreeView;
    pnlErrorSetting: TPanel;
    pnlErrorTop: TPanel;
    pnlErrorButtom: TPanel;
    lvErrorKeys: TListView;
    pnlErrorKeyTButtom: TPanel;
    srchErrorKey: TSearchBox;
    lblSearchkey: TLabel;
    btnView: TButton;
    btnDelete: TButton;
    btnSave: TButton;
    grpErrorKey: TGroupBox;
    lblKeycode: TLabel;
    edtkeycode: TEdit;
    lblDefinition: TLabel;
    mmoKeyDefinition: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure tvTaskManagerClick(Sender: TObject);
    procedure tvGeneralClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Setting: TSetting;

implementation

{$R *.dfm}

procedure TSetting.FormCreate(Sender: TObject);
var
  lvX: Integer;
begin
  lvX := lvErrorKeys.Width;
  lvErrorKeys.Columns[0].Width := Round((lvX * 10) / 100);
  lvErrorKeys.Columns[1].Width := Round((lvX * 30) / 100);
  lvErrorKeys.Columns[2].Width := Round((lvX * 59) / 100);
  lvErrorKeys.Refresh;
  pnlRSetting.Visible := true;
  pnlErrorSetting.Visible := False;
  pnlASchedule.Visible := False;
end;

procedure TSetting.tvGeneralClick(Sender: TObject);
var
  selectText: String;
begin
  if tvGeneral.Selected <> nil then
  begin
    selectText := tvGeneral.Selected.Text;
    if SameText(selectText, 'Error Setting') then
    begin
      pnlASchedule.Visible := False;
      pnlErrorSetting.Visible := true;
    end
    else
    begin
      pnlErrorSetting.Visible := False;
      pnlASchedule.Visible := False;
      pnlRSetting.Visible := true;
    end;

  end;

end;

procedure TSetting.tvTaskManagerClick(Sender: TObject);
var
  selectText: String;
begin
  if tvTaskManager.Selected <> nil then
  begin
    selectText := tvTaskManager.Selected.Text;

    if SameText(selectText, 'Automatic Schedule') then
    begin
      pnlASchedule.Visible := true;
      pnlErrorSetting.Visible := False;
    end
    else
    begin
      pnlErrorSetting.Visible := False;
      pnlASchedule.Visible := False;
      pnlRSetting.Visible := true;
    end;

  end;

end;

end.
