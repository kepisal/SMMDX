object Setting: TSetting
  Left = 0
  Top = 0
  Caption = 'Setting'
  ClientHeight = 461
  ClientWidth = 784
  Color = clBtnFace
  Constraints.MaxHeight = 600
  Constraints.MaxWidth = 800
  Constraints.MinHeight = 500
  Constraints.MinWidth = 800
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ctgrypnlgrpSetting: TCategoryPanelGroup
    Left = 0
    Top = 0
    Height = 461
    VertScrollBar.Tracking = True
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    TabOrder = 0
    object ctgrypnl2: TCategoryPanel
      Top = 225
      Height = 234
      Caption = 'Task Manager'
      TabOrder = 0
      ExplicitWidth = 185
      object tvTaskManager: TTreeView
        Left = 0
        Top = 0
        Width = 196
        Height = 208
        Align = alClient
        Indent = 19
        RowSelect = True
        TabOrder = 0
        OnClick = tvTaskManagerClick
        Items.NodeData = {
          0301000000420000000000000000000000FFFFFFFFFFFFFFFF00000000000000
          000000000001124100750074006F006D00610074006900630020005300630068
          006500640075006C006500}
        ExplicitLeft = 80
        ExplicitTop = 64
        ExplicitWidth = 121
        ExplicitHeight = 97
      end
    end
    object ctgrypnlGeneral: TCategoryPanel
      Top = 0
      Height = 225
      Caption = 'General'
      TabOrder = 1
      ExplicitWidth = 185
      object tvGeneral: TTreeView
        Left = 0
        Top = 0
        Width = 196
        Height = 199
        Align = alClient
        Indent = 19
        TabOrder = 0
        OnClick = tvGeneralClick
        Items.NodeData = {
          0304000000360000000000000000000000FFFFFFFFFFFFFFFF00000000000000
          0000000000010C55007300650072002000530065007400740069006E0067003A
          0000000000000000000000FFFFFFFFFFFFFFFF00000000000000000000000001
          0E4D006F00640075006C0065002000530065007400740069006E006700380000
          000000000000000000FFFFFFFFFFFFFFFF000000000000000000000000010D45
          00720072006F0072002000530065007400740069006E0067003A000000000000
          0000000000FFFFFFFFFFFFFFFF000000000000000000000000010E4300750073
          0074006F006D002000530065007400740069006E006700}
        ExplicitLeft = 75
        ExplicitTop = -112
        ExplicitWidth = 121
        ExplicitHeight = 97
      end
    end
  end
  object pnlRSetting: TPanel
    Left = 200
    Top = 0
    Width = 584
    Height = 461
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 312
    ExplicitTop = 232
    ExplicitWidth = 185
    ExplicitHeight = 41
    object pnlASchedule: TPanel
      Left = 1
      Top = 1
      Width = 582
      Height = 459
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 296
      ExplicitTop = 200
      ExplicitWidth = 185
      ExplicitHeight = 41
      object pnlASTop: TPanel
        Left = 1
        Top = 1
        Width = 580
        Height = 232
        Align = alTop
        TabOrder = 0
        ExplicitLeft = 5
        ExplicitTop = 185
        object grpAStop: TGroupBox
          AlignWithMargins = True
          Left = 26
          Top = 11
          Width = 528
          Height = 212
          Margins.Left = 25
          Margins.Top = 10
          Margins.Right = 25
          Margins.Bottom = 8
          Align = alClient
          Caption = ' Schedule Setting : '
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object lblBegintask: TLabel
            Left = 16
            Top = 24
            Width = 104
            Height = 16
            Caption = 'Begin to the task :'
          end
          object lblStart: TLabel
            Left = 269
            Top = 24
            Width = 37
            Height = 16
            Caption = 'Start :'
          end
          object lblMailTo: TLabel
            Left = 258
            Top = 54
            Width = 47
            Height = 16
            Caption = 'Mail to :'
          end
          object cbbtaskType: TComboBox
            Left = 126
            Top = 21
            Width = 130
            Height = 24
            TabOrder = 0
            Items.Strings = (
              'On a Schedule'
              'At Log on'
              'At Start up')
          end
          object dtpSStartDate: TDateTimePicker
            Left = 312
            Top = 21
            Width = 105
            Height = 24
            Date = 42400.694158958340000000
            Time = 42400.694158958340000000
            TabOrder = 1
          end
          object dtpSTime: TDateTimePicker
            Left = 419
            Top = 21
            Width = 96
            Height = 24
            Date = 42400.694774618050000000
            Format = 'hh:mm:ss'
            Time = 42400.694774618050000000
            DateMode = dmUpDown
            TabOrder = 2
          end
          object rgChoose: TRadioGroup
            Left = 18
            Top = 51
            Width = 102
            Height = 126
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            Items.Strings = (
              'One time'
              'Daily'
              'Weekly')
            ParentFont = False
            TabOrder = 3
          end
          object chklstDays: TCheckListBox
            Left = 126
            Top = 51
            Width = 130
            Height = 126
            Items.Strings = (
              'Monday'
              'Tuesday'
              'Wednesday'
              'Thursday'
              'Friday'
              'Saturday'
              'Sunday')
            TabOrder = 4
          end
          object edtadminMail: TEdit
            Left = 305
            Top = 51
            Width = 210
            Height = 24
            TabOrder = 5
          end
          object btnRemove: TButton
            Left = 161
            Top = 181
            Width = 95
            Height = 25
            Caption = 'Remove'
            TabOrder = 6
          end
          object btnOk: TButton
            Left = 305
            Top = 181
            Width = 96
            Height = 25
            Caption = 'OK'
            TabOrder = 7
          end
          object btnCancle: TButton
            Left = 430
            Top = 181
            Width = 85
            Height = 25
            Caption = 'Cancel'
            TabOrder = 8
          end
          object mmoMailBody: TMemo
            Left = 305
            Top = 81
            Width = 210
            Height = 96
            TabOrder = 9
          end
        end
      end
      object pnlASButtom: TPanel
        Left = 1
        Top = 226
        Width = 580
        Height = 232
        Align = alBottom
        TabOrder = 1
        ExplicitTop = 1
        ExplicitWidth = 578
      end
    end
    object pnlErrorSetting: TPanel
      Left = 1
      Top = 1
      Width = 582
      Height = 459
      Align = alClient
      TabOrder = 1
      ExplicitLeft = 200
      ExplicitTop = 208
      ExplicitWidth = 185
      ExplicitHeight = 41
      object pnlErrorTop: TPanel
        Left = 1
        Top = 1
        Width = 580
        Height = 158
        Align = alTop
        TabOrder = 0
        object grpErrorKey: TGroupBox
          AlignWithMargins = True
          Left = 16
          Top = 16
          Width = 548
          Height = 126
          Margins.Left = 15
          Margins.Top = 15
          Margins.Right = 15
          Margins.Bottom = 15
          Align = alClient
          Caption = ' Setting :'
          TabOrder = 0
          ExplicitLeft = -202
          ExplicitTop = 81
          object lblKeycode: TLabel
            Left = 80
            Top = 23
            Width = 32
            Height = 13
            Caption = 'Code :'
          end
          object lblDefinition: TLabel
            Left = 60
            Top = 47
            Width = 52
            Height = 13
            Caption = 'Definition :'
          end
          object edtkeycode: TEdit
            Left = 117
            Top = 15
            Width = 316
            Height = 21
            Alignment = taCenter
            AutoSelect = False
            AutoSize = False
            BevelInner = bvNone
            BevelOuter = bvNone
            TabOrder = 0
          end
          object mmoKeyDefinition: TMemo
            Left = 118
            Top = 41
            Width = 315
            Height = 75
            TabOrder = 1
          end
        end
      end
      object pnlErrorButtom: TPanel
        Left = 1
        Top = 159
        Width = 580
        Height = 299
        Align = alClient
        TabOrder = 1
        ExplicitTop = 235
        ExplicitHeight = 223
        object lvErrorKeys: TListView
          AlignWithMargins = True
          Left = 11
          Top = 33
          Width = 558
          Height = 255
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alClient
          Columns = <
            item
              Caption = 'ID'
            end
            item
              Caption = 'Key Code'
            end
            item
              Caption = 'Definition'
            end>
          TabOrder = 0
          ViewStyle = vsReport
          ExplicitTop = 13
          ExplicitHeight = 201
        end
        object pnlErrorKeyTButtom: TPanel
          Left = 1
          Top = 1
          Width = 578
          Height = 32
          Align = alTop
          BevelOuter = bvNone
          Padding.Right = 10
          TabOrder = 1
          object lblSearchkey: TLabel
            Left = 10
            Top = 8
            Width = 39
            Height = 16
            Caption = 'Enter :'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
          end
          object srchErrorKey: TSearchBox
            Left = 63
            Top = 3
            Width = 209
            Height = 25
            AutoSelect = False
            AutoSize = False
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            TextHint = 'Enter Key code ...'
            ButtonWidth = 25
          end
          object btnView: TButton
            AlignWithMargins = True
            Left = 493
            Top = 0
            Width = 75
            Height = 32
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alRight
            Caption = 'View'
            TabOrder = 1
            ExplicitLeft = 310
            ExplicitTop = 1
            ExplicitHeight = 35
          end
          object btnDelete: TButton
            AlignWithMargins = True
            Left = 415
            Top = 0
            Width = 75
            Height = 32
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alRight
            Caption = 'Delete'
            TabOrder = 2
            ExplicitLeft = 310
            ExplicitTop = 1
            ExplicitHeight = 35
          end
          object btnSave: TButton
            AlignWithMargins = True
            Left = 337
            Top = 0
            Width = 75
            Height = 32
            Margins.Top = 0
            Margins.Right = 0
            Margins.Bottom = 0
            Align = alRight
            Caption = 'Save'
            TabOrder = 3
            ExplicitLeft = 283
            ExplicitTop = -3
          end
        end
      end
    end
  end
end
