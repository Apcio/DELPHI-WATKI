unit Worker;

interface

uses
  System.Classes, System.SyncObjs, System.SysUtils, System.IOUtils, VCL.Forms,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.UI,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.FBDef,
  FireDAC.Phys.IBBase, FireDAC.Phys.FB;

type
  TWorker = class(TThread)
    private
      id: Integer;
      it: Integer;
      status: string;
      mutex: TMutex;

      fdCon: TFDConnection;
      readSQL: TFDQuery;
      writeSQL: TFDQuery;

    public
      constructor Create(no: Integer; m: TMutex); overload;
      destructor Destroy(); override;

      procedure Execute(); override;
      procedure pause();
      procedure resume();
      function getId(): Integer;
      function getIterator(): Integer;
      function getStatus(): string;
  end;

var
  workerC: ^TWorker;

implementation

uses
  Main;


constructor TWorker.Create(no: Integer; m: TMutex);
begin
  inherited Create(true);

  it := 0;
  id := no;
  mutex := m;
  Self.Priority := tpIdle;
  status := 'Zatrzymany';

  fdCon := TFDConnection.Create(nil);
  fdCon.DriverName := 'FB';
  fdCon.Params.UserName := 'SYSDBA';
  fdCon.Params.Password := 'masterkey';
  fdCon.Params.Database := TPath.GetDirectoryName(Application.ExeName) + '\dane.FDB';
  fdCon.Params.Add('Server=localhost');
  fdCon.Params.Add('Protocol=local');
  fdCon.Params.Add('CharacterSet=Win1250');
  fdCon.Open();

  readSQL := TFDQuery.Create(nil);
  readSQL.Connection := fdCon;
  readSQL.SQL.Text := 'SELECT FIRST 5 * FROM TABELA_TEST ORDER BY IDTEST 1 DESC';

  writeSQL := TFDQuery.Create(nil);
  writeSQL.Connection := fdCon;
  writeSQL.SQL.Text := 'INSERT INTO TABLE_ID VALUES(:id)';

end;

destructor TWorker.Destroy();
begin
  it := 0;

  writeSQL.Free();
  readSQL.Free();
  fdCon.Free();

  inherited;
end;

procedure TWorker.pause();
begin
  status := 'Wstrzymany';
  Self.Suspended := true;
end;

procedure TWorker.resume();
begin
  status := 'Pracuje';
  Self.Suspended := false;
end;

function TWorker.getId(): Integer;
begin
  mutex.Acquire();
  Result := id;
  mutex.Release();
end;

function TWorker.getIterator(): Integer;
begin
  mutex.Acquire();
  Result := it;
  mutex.Release();
end;

function TWorker.getStatus(): string;
begin
  Result := status;
end;

procedure TWorker.Execute();
var
  tmp: Integer;
begin
  Self.Priority := tpNormal;
  status := 'Pracuje';
  it := 0;

  while not Terminated do
  begin
    tmp := Form1.readVariable(Self);
    Sleep(50);

    Form1.writeVariable(Self, it);
    Sleep(50);

    Form1.rwVariable(Self, it);
    Sleep(50);

    Form1.readSQL(Self);
    readSQL.Close();
    readSQL.Open();
    Sleep(50);

    Form1.writeSQL(Self);
    writeSQL.Close();
    writeSQL.ParamByName('id').AsInteger := id;
    writeSQL.ExecSQL();
    Sleep(50);

    Inc(it);
    Sleep(150);
    Yield();
  end;

  Self.Priority := tpIdle;
  status := 'Zatrzymany';
end;

end.
