library PrDll;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters.

  Important note about VCL usage: when this DLL will be implicitly
  loaded and this DLL uses TWicImage / TImageCollection created in
  any unit initialization section, then Vcl.WicImageInit must be
  included into your library's USES clause. }

uses
  System.SysUtils,
  System.Classes,System.Variants,
  System.IniFiles, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Datasnap.DBClient, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,FireDAC.DApt, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet;

{$R *.res}

var
 fdcConexao: TFDConnection;

  function conexao:string; stdcall;
  var
    ini: TIniFile;
   vHost,vPort,vDB,vUser,vPass :String;
  begin
   fdcConexao := TFDConnection.Create(nil);
   ini:=TInifile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
   Try
     vHost:=Ini.ReadString('DATABASE','host','localhost');
     vPort:=ini.ReadString('DATABASE','Port','3306');
     vDB:=ini.ReadString('DATABASE','Database','wktec');
     vUser:=ini.ReadString('DATABASE','Username','root');
     vPass:=ini.ReadString('DATABASE','Password','senha');
     fdcConexao.Params.Clear;
     fdcConexao.DriverName:='MySQL';
     fdcConexao.Params.Add('Server=' + vHost);
     fdcConexao.Params.Add('Port=' + vPort);
     fdcConexao.Params.Add('Database=' + vDB);
     fdcConexao.Params.Add('User_Name=' + vUser);
     fdcConexao.Params.Add('Password=' + vPass);
     fdcConexao.Params.Add('CharacterSet=utf8mb4');
     fdcConexao.LoginPrompt := False;

     Try
       fdcConexao.Connected := True;
       result :='Conectado!!!';
     Except
       on E: Exception do
          ShowMessage('Erro na conexão: '+ E.Message);
     end;

   Finally
     Ini.Free;

   End;


  end;

 Function CancelarPedido(numPedido:string):string;stdcall;
 var
   qryCancelar: TFDQuery;
   traPrincipal: TFDTransaction;
 Begin
    qryCancelar := TFDQuery.Create(nil);
    traPrincipal := TFDTransaction.Create(nil);
    try
      qryCancelar.Connection := fdcConexao;
      traPrincipal.Connection:= fdcConexao;
      traPrincipal.Options.Isolation := xiReadCommitted;
      fdcConexao.Transaction := traPrincipal;
      traPrincipal.StartTransaction;
      qryCancelar.Close;
      qryCancelar.SQL.Clear;
      qryCancelar.SQL.Add('delete from pedidos_produtos where num_pedido = '+Trim(numPedido));
      qryCancelar.ExecSQL;
      qryCancelar.Close;
      qryCancelar.SQL.Clear;
      qryCancelar.SQL.Add('delete from pedidos_dados_gerais where num_pedido = '+Trim(numPedido));
      qryCancelar.ExecSQL;
      traPrincipal.Commit;
      result := 'Pedido Excluído';
    except
       on E: Exception do
        Begin
          if traPrincipal.Active then
             traPrincipal.Rollback;
          ShowMessage('Erro ao excluir pedido: ' + E.Message);
        End;

    end;
    qryCancelar.Free;
 End;

  function PesqDescProduto(cdProduto:String):string;stdcall;
  var
   qryDescProd: TFDQuery;
  begin
    qryDescProd := TFDQuery.Create(nil);
    qryDescProd.Connection := fdcConexao;
    qryDescProd.Close;
    qryDescProd.SQL.Clear;
    qryDescProd.SQL.Add('Select descricao from produtos where codigo = '+ cdProduto);
    qryDescProd.Open;
    result := qryDescProd.FieldByName('descricao').AsString;
    qryDescProd.Free
  end;

  function PesqPunitProduto(cdProduto:String):string;stdcall;
  var
   qryPunitProduto: TFDQuery;
  Begin
    qryPunitProduto := TFDQuery.Create(nil);
    qryPunitProduto.Connection := fdcConexao;
    qryPunitProduto.Close;
    qryPunitProduto.SQL.Clear;
    qryPunitProduto.SQL.Add('Select preco_venda from produtos where codigo = '+ cdProduto);
    qryPunitProduto.Open;
    result := qryPunitProduto.FieldByName('preco_venda').AsString;
    qryPunitProduto.Free;
  End;

  Function InserirPedidoProd(num_pedido,cod_produto,quant:Integer;vlr_unitario,vlr_total:real):string;stdcall;
  var
    qryInsere : TFDQuery;
    traPrincipal: TFDTransaction;
  Begin
    qryInsere := TFDQuery.Create(nil);
    traPrincipal := TFDTransaction.Create(nil);
    Try
      qryInsere.Connection := fdcConexao;
      traPrincipal.Connection:= fdcConexao;
      traPrincipal.Options.Isolation := xiReadCommitted;
      fdcConexao.Transaction := traPrincipal;
      traPrincipal.StartTransaction;

      qryInsere.Close;
      qryInsere.SQL.Clear;
      qryInsere.SQL.Add('Insert into pedidos_produtos (num_pedido,cod_produto,quant,vlr_unitario,vlr_total)');
      qryInsere.SQL.Add('Values (:num_pedido, :cod_produto,:quant,:vlr_unitario,:vlr_total)');
      qryInsere.Params.ParamByName('num_pedido').AsInteger := num_pedido;
      qryInsere.Params.ParamByName('cod_produto').AsInteger := cod_produto;
      qryInsere.Params.ParamByName('quant').AsInteger := quant;
      qryInsere.Params.ParamByName('vlr_unitario').AsFloat := vlr_unitario;
      qryInsere.Params.ParamByName('vlr_total').AsFloat := vlr_total;
      qryInsere.ExecSQL;
      traPrincipal.Commit;
      result := 'Pedido inserido com êxito';
      Except
       on E: Exception do
        Begin
          if traPrincipal.Active then
             traPrincipal.Rollback;
          showmessage('Erro na inserção do pedido: '+ E.Message);
        End;
    End;
    qryInsere.Free;


  End;

  Function InserirPedidoResumo(dtEmissao:TDate;cdCliente:Integer;valTot:Real):integer;stdcall;
  var
   qryInsere : TFDQuery;
   traPrincipal: TFDTransaction;
  Begin
    qryInsere := TFDQuery.Create(nil);
    traPrincipal := TFDTransaction.Create(nil);
    Try
      qryInsere.Connection := fdcConexao;
      traPrincipal.Connection:= fdcConexao;
      traPrincipal.Options.Isolation := xiReadCommitted;
      fdcConexao.Transaction := traPrincipal;
      traPrincipal.StartTransaction;

      qryInsere.Close;
      qryInsere.SQL.Clear;
      qryInsere.SQL.Add('Insert into pedidos_dados_gerais (data_emissao,cod_cliente,valor_total)');
      qryInsere.SQL.Add('Values (:dtemissao, :cdcliente,:valtot)');
      qryInsere.Params.ParamByName('dtemissao').AsDate := dtEmissao;
      qryInsere.Params.ParamByName('cdcliente').AsInteger := cdCliente;
      qryInsere.Params.ParamByName('valtot').AsFloat := valTot;
      qryInsere.ExecSQL;
      traPrincipal.Commit;
      result := fdcConexao.GetLastAutoGenValue('num_pedido');
    Except
       on E: Exception do
        Begin
           if traPrincipal.Active then
             traPrincipal.Rollback;
           showmessage('Erro na inserção do pedido: '+ E.Message);
        End;
    End;
    qryInsere.Free;
  End;

  function RodarSelect(vQuery:string):TFDQuery; stdcall;
  var
    vsQuery: TFDQuery;
  begin
    vsQuery:= TFDQuery.Create(nil);
    try
      vsQuery.Connection := fdcConexao;
      vsQuery.close;
      vsQuery.SQL.Clear;
      vsQuery.SQL.Add(vQuery);
      vsQuery.Open;
      result := vsQuery;
    except
      on E: Exception do
      begin
        vsQuery.Free;
        raise Exception.Create('Erro ao executar a pesquisa: ' + E.message);
      end;

    end;

  end;

  procedure Encerra;stdcall;
  begin
    fdcConexao.Free;
  end;

  exports
   conexao, CancelarPedido, PesqDescProduto, PesqPunitProduto,
   InserirPedidoResumo,InserirPedidoProd, Encerra, RodarSelect;

begin
end.
