object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 286
  ClientWidth = 362
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 104
    Top = 11
    Width = 47
    Height = 13
    Caption = 'Nr watku:'
  end
  object Label7: TLabel
    Left = 255
    Top = 11
    Width = 24
    Height = 13
    Caption = 'Jest:'
  end
  object IloscWatkow: TLabel
    Left = 288
    Top = 11
    Width = 61
    Height = 13
    Caption = 'IloscWatkow'
  end
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Nowy watek'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 8
    Top = 39
    Width = 75
    Height = 25
    Caption = 'Usun watek'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 96
    Width = 75
    Height = 25
    Caption = 'W'#261'tek start'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 8
    Top = 127
    Width = 75
    Height = 25
    Caption = 'W'#261'tek stop'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 8
    Top = 168
    Width = 75
    Height = 25
    Caption = 'W'#261'tek pauza'
    TabOrder = 4
    OnClick = Button5Click
  end
  object Button6: TButton
    Left = 8
    Top = 199
    Width = 75
    Height = 25
    Caption = 'W'#261'tek przyw.'
    TabOrder = 5
    OnClick = Button6Click
  end
  object GroupBox1: TGroupBox
    Left = 104
    Top = 47
    Width = 226
    Height = 90
    Caption = 'Informacje o watku'
    TabOrder = 6
    object Label2: TLabel
      Left = 16
      Top = 24
      Width = 47
      Height = 13
      Caption = 'Nr w'#261'tku:'
    end
    object WatekNr: TLabel
      Left = 69
      Top = 24
      Width = 31
      Height = 13
      Caption = 'Watek'
    end
    object Label3: TLabel
      Left = 16
      Top = 43
      Width = 136
      Height = 13
      Caption = 'Wewn'#281'trzny iterator watku:'
    end
    object WatekIterator: TLabel
      Left = 157
      Top = 43
      Width = 69
      Height = 13
      Caption = 'WatekIterator'
    end
    object Label4: TLabel
      Left = 16
      Top = 62
      Width = 66
      Height = 13
      Caption = 'Uruchomiony:'
    end
    object WatekUruchomiony: TLabel
      Left = 88
      Top = 62
      Width = 93
      Height = 13
      Caption = 'WatekUruchomiony'
    end
  end
  object GroupBox2: TGroupBox
    Left = 104
    Top = 143
    Width = 226
    Height = 114
    Caption = 'Informacje'
    TabOrder = 7
    object Label5: TLabel
      Left = 16
      Top = 24
      Width = 77
      Height = 13
      Caption = 'Aktualnie czyta:'
    end
    object Label6: TLabel
      Left = 16
      Top = 43
      Width = 90
      Height = 13
      Caption = 'Aktualnie zapisuje:'
    end
    object InfoCzyta: TLabel
      Left = 99
      Top = 24
      Width = 48
      Height = 13
      Caption = 'InfoCzyta'
    end
    object InfoZapisuje: TLabel
      Left = 112
      Top = 43
      Width = 60
      Height = 13
      Caption = 'InfoZapisuje'
    end
    object Label8: TLabel
      Left = 16
      Top = 72
      Width = 52
      Height = 13
      Caption = 'SQL czyta:'
    end
    object Label9: TLabel
      Left = 16
      Top = 91
      Width = 65
      Height = 13
      Caption = 'SQL zapisuje:'
    end
    object InfoSqlCzyta: TLabel
      Left = 99
      Top = 72
      Width = 62
      Height = 13
      Caption = 'InfoSqlCzyta'
    end
    object InfoSqlZapisuje: TLabel
      Left = 99
      Top = 91
      Width = 74
      Height = 13
      Caption = 'InfoSqlZapisuje'
    end
  end
  object SpinEdit1: TJvSpinEdit
    Left = 157
    Top = 8
    Width = 92
    Height = 21
    TabOrder = 8
    OnChange = SpinEdit1Change
  end
  object Timer1: TTimer
    Interval = 200
    OnTimer = Timer1Timer
    Left = 64
    Top = 64
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'CharacterSet=WIN1250'
      'DriverID=FB'
      'User_Name=sysdba'
      'Password=masterkey')
    LoginPrompt = False
    Left = 320
    Top = 40
  end
  object fdRead: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT FIRST 5 * FROM TABELA_TEST ORDER BY IDTEST 1 DESC')
    Left = 320
    Top = 111
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 48
    Top = 231
  end
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    VendorLib = 
      'D:\Programy\Baza danych\FireBird\2.5.5\Firebird-2.5.5.26952-0_Wi' +
      'n32\bin\fbclient.dll'
    Left = 240
    Top = 119
  end
  object fdWrite: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'INSERT INTO TABLE_ID VALUES(:id)')
    Left = 320
    Top = 159
    ParamData = <
      item
        Name = 'ID'
        DataType = ftInteger
        ParamType = ptInput
        Value = Null
      end>
  end
end
