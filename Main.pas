unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin, System.SyncObjs,
  Worker, Vcl.Mask, JvExMask, JvSpin, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.VCLUI.Wait, FireDAC.Phys.IBBase,
  FireDAC.Comp.UI, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.IOUtils;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    WatekNr: TLabel;
    Label3: TLabel;
    WatekIterator: TLabel;
    GroupBox2: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    InfoCzyta: TLabel;
    InfoZapisuje: TLabel;
    SpinEdit1: TJvSpinEdit;
    Label7: TLabel;
    IloscWatkow: TLabel;
    Label4: TLabel;
    WatekUruchomiony: TLabel;
    Timer1: TTimer;
    FDConnection1: TFDConnection;
    fdRead: TFDQuery;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    fdWrite: TFDQuery;
    Label8: TLabel;
    Label9: TLabel;
    InfoSqlCzyta: TLabel;
    InfoSqlZapisuje: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Private declarations }
    workers: TThreadList;
    count: Integer;
    increment: Integer;
    mutex: TMutex;

    rValue: Integer;
    wValue: Integer;
    rwValue: Integer;

    procedure deleteWorker(i: integer);

  public
    procedure writeVariable(var w: TWorker; v: Integer);
    procedure readSQL(var w: TWorker);
    procedure writeSQL(var w: TWorker);
    function readVariable(var w: TWorker): Integer;
    function rwVariable(var w: TWorker; v: Integer): Integer;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation


{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Inc(Increment);

  New(workerC);
  workerC^ := TWorker.Create(Increment, mutex);

  workers.Add(workerC);

  SpinEdit1.Value := count;
  SpinEdit1.MaxValue := count;
  SpinEdit1.MinValue := 0;

  Inc(count);
  IloscWatkow.Caption := IntToStr(count);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FDPhysFBDriverLink1.VendorLib := TPath.GetDirectoryName(Application.ExeName) + '\fbclient.dll';
  workers := TThreadList.Create();

  SpinEdit1.MinValue := -1;
  SpinEdit1.MaxValue := -1;
  SpinEdit1.Value := -1;

  count := 0;
  IloscWatkow.Caption := '0';
  Increment := 0;

  FDConnection1.DriverName := 'FB';
  FDConnection1.Params.UserName := 'SYSDBA';
  FDConnection1.Params.Password := 'masterkey';
  FDConnection1.Params.Database := TPath.GetDirectoryName(Application.ExeName) + '\dane.FDB';
  FDConnection1.Params.Add('Server=localhost');
  FDConnection1.Params.Add('Protocol=local');
  FDConnection1.Params.Add('CharacterSet=Win1250');

  FDConnection1.Open();

  mutex := TMutex.Create(nil, false, '{FE8A818E-13C1-4AED-9D8B-523173F7F09E}');
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i: integer;
  list: TList;
begin
  list := workers.LockList();

  {Zatrzymaj wszystkie zadania}
  for i := 0 to list.Count - 1 do
  begin
    workerC := list.Items[i];
    workerC.Terminate();
  end;

  {teraz usun wszystkie watki}
  for i := 0 to list.Count - 1 do
  begin
    workerC := list.Items[i];

    if workerC.Finished = false then
      workerC.WaitFor();

    workerC.Free();
    dispose(workerC);
  end;

  workers.Free();
  mutex.Free();
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
var
  list: TList;
  i: integer;
begin
  i := Round(SpinEdit1.Value);

  if (i < 0) or (i > (count - 1)) then
    Exit();

  list := workers.LockList();
  workerC := list.Items[i];

  WatekNr.Caption := IntToStr(workerC.getId());
  WatekIterator.Caption := IntToStr(workerC.getIterator());
  WatekUruchomiony.Caption := workerC.getStatus();

  workers.UnlockList();
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i: Integer;
  list: TList;
begin
  i := Round(SpinEdit1.Value);

  if (i < 0) or (i > (count - 1)) then
  begin
    Exit();
  end;

  list := workers.LockList();
  workerC := list.Items[i];

  WatekNr.Caption := IntToStr(WorkerC.getId());
  WatekIterator.Caption := IntToStr(WorkerC.getIterator());
  WatekUruchomiony.Caption := WorkerC.getStatus();

  workers.UnlockList();
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i: Integer;
begin
  i := Round(SpinEdit1.Value);

  if (i < 0) or (i > (count - 1)) then
  begin
    ShowMessage('Z³y numer');
    Exit();
  end;

  deleteWorker(i);
  Dec(count);
  IloscWatkow.Caption := IntToStr(count);

  SpinEdit1.Value := count - 1;
  SpinEdit1.MaxValue := count - 1;
  SpinEdit1.MinValue := 0;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i: Integer;
  list: TList;
begin
  i := Round(SpinEdit1.Value);
  if (i < 0) or (i > (count - 1)) then
  begin
    ShowMessage('Z³y numer');
    Exit();
  end;

  list := workers.LockList();
  workerC := list.Items[i];
  workerC.Start();
  workers.UnlockList();
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i: Integer;
  list: TList;
begin
  i := Round(SpinEdit1.Value);
  if (i < 0) or (i > (count - 1)) then
  begin
    ShowMessage('Z³y numer');
    Exit();
  end;

  list := workers.LockList();
  workerC := list.Items[i];
  workerC.Terminate();
  workerC.WaitFor();
  workers.UnlockList();
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  i: Integer;
  list: TList;
begin
  i := Round(SpinEdit1.Value);
  if (i < 0) or (i > (count - 1)) then
  begin
    ShowMessage('Z³y numer');
    Exit();
  end;

  list := workers.LockList();
  workerC := list.Items[i];
  workerC.pause();
  workers.UnlockList();
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  i: Integer;
  list: TList;
begin
  i := Round(SpinEdit1.Value);
  if (i < 0) or (i > (count - 1)) then
  begin
    ShowMessage('Z³y numer');
    Exit();
  end;

  list := workers.LockList();
  workerC := list.Items[i];
  workerC.resume();
  workers.UnlockList();
end;

procedure TForm1.deleteWorker(i: integer);
var
  w: ^TWorker;
  list: TList;
begin
  list := workers.LockList;

  w := list.Items[i];

  workers.Remove(w);
  w.Free();
  Dispose(w);

  workers.UnlockList();
end;

procedure TForm1.writeVariable(var w: TWorker; v: Integer);
begin
  mutex.Acquire();
  InfoZapisuje.Caption := IntToStr(w.getId());
  wValue := v;
  mutex.Release();
end;

function TForm1.readVariable(var w: TWorker): Integer;
begin
  mutex.Acquire();
  InfoCzyta.Caption := IntToStr(w.getId());
  Result := rValue;
  mutex.Release();
end;

function TForm1.rwVariable(var w: TWorker; v: Integer): Integer;
begin
  mutex.Acquire();
  InfoCzyta.Caption := IntToStr(w.getId());
  InfoZapisuje.Caption := IntToStr(w.getId());
  Result := rwValue;
  rwValue := v;
  mutex.Release();
end;

procedure TForm1.readSQL(var w: TWorker);
begin
  mutex.Acquire();
  InfoSqlCzyta.Caption := IntToStr(w.getId());

  //fdRead.Close();
  //fdRead.Open();
  mutex.Release();
end;

procedure TForm1.writeSQL(var w: TWorker);
begin
  //Je¿eli u¿yjê FireDACa jako jedno po³¹czenie a potem z kilku w¹tków spróbujê wykonaæ SQL
  // wtedy przestan¹ one pracowaæ. Dlatego ka¿dy w¹tek musi mieæ swoje po³¹czenie
  //http://docwiki.embarcadero.com/RADStudio/XE6/en/Multithreading_(FireDAC)
  mutex.Acquire();
  InfoSqlZapisuje.Caption := IntToStr(w.getId());

  //fdWrite.Close();
  //fdWrite.ParamByName('id').AsInteger := w.getIterator();
  //fdWrite.ExecSQL();
  mutex.Release();
end;

end.
