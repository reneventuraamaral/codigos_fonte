unit tela1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.IniFiles, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Datasnap.DBClient, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,FireDAC.DApt, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    grdPedido: TDBGrid;
    dsPedido: TDataSource;
    cdsPedido: TClientDataSet;
    cdsPedidocodProd: TIntegerField;
    cdsPedidoproduto: TStringField;
    cdsPedidoprunit: TCurrencyField;
    cdsPedidoquant: TIntegerField;
    cdsPedidoprtot: TCurrencyField;
    stbRodape: TStatusBar;
    fdcConexao: TFDConnection;
    FDTransaction1: TFDTransaction;
    Panel2: TPanel;
    Label5: TLabel;
    Label7: TLabel;
    edCliente: TEdit;
    edtCodPedido: TEdit;
    btnPesqPedido: TButton;
    Panel3: TPanel;
    Label6: TLabel;
    edtValTot: TEdit;
    GroupBox2: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edCodigo: TEdit;
    edQuant: TEdit;
    edPunit: TEdit;
    btnInsert: TButton;
    btnCancela: TButton;
    qryPesqPedido: TFDQuery;
    Button1: TButton;
    btnFim: TButton;

    procedure btnInsertClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grdPedidoKeyDown(Sender: TObject; var Key: Word;
         Shift: TShiftState);
    procedure CalculaGrid;
    procedure PesquisaProduto(cod:string);
    procedure edQuantExit(Sender: TObject);
    procedure btnPesqPedidoClick(Sender: TObject);
    procedure btnCancelaClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
	procedure LimpaCampos;
	procedure LimpaGrid;
    procedure btnFimClick(Sender: TObject);
    procedure edClienteChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  Form2: TForm2;
  cValtot : Currency;
  op,msg:String;
  
  Function conexao:string; stdcall; external 'PrDll.dll';
  Function CancelarPedido(numPedido:string):string;stdcall; external 'PrDll.dll';
  function PesqDescProduto(cdProduto:String):string;stdcall; external 'PrDll.dll';
  function PesqPunitProduto(cdProduto:String):string;stdcall; external 'PrDll.dll'; 
  Function InserirPedidoResumo(dtEmissao:TDate;cdCliente:Integer;valTot:Real):integer;stdcall; external 'PrDll.dll';
  Function InserirPedidoProd(num_pedido,cod_produto,quant:Integer;vlr_unitario,vlr_total:real):String;stdcall; external 'PrDll.dll';
  procedure Encerra;stdcall; external 'PrDll.dll';
  function RodarSelect(vQuery:string):TFDQuery; stdcall; external 'PrDll.dll';
  
implementation

{$R *.dfm}

procedure TForm2.btnCancelaClick(Sender: TObject);
begin
   stbRodape.Panels[1].Text:=CancelarPedido(edtCodPedido.text);
end;

procedure TForm2.btnFimClick(Sender: TObject);
begin
  Encerra;
  Close;
end;

procedure TForm2.btnInsertClick(Sender: TObject);
begin
 cdsPedido.Open;
 if op='E' then cdsPedido.Edit
           else cdsPedido.Append;
 cdsPedido.FieldByName('codProd').AsInteger:=StrToInt(edCodigo.Text);
 //pesquisaproduto(edCodigo.Text);
 cdsPedido.FieldByName('produto').AsString:=PesqDescProduto(Trim(edCodigo.Text));//qryPesquisa.FieldByName('descricao').AsString;
 cdsPedido.FieldByName('quant').AsInteger:=StrToInt(edQuant.Text);
 cdsPedido.FieldByName('prunit').AsFloat:=StrToFloat(edPunit.Text);
 cdsPedido.FieldByName('prtot').AsFloat:=(StrToFloat(edPunit.Text)*StrToInt(edQuant.Text));
 cdsPedido.Post;
 calculaGrid;
 LimpaCampos;
end;

procedure TForm2.btnPesqPedidoClick(Sender: TObject);
var
  qryPesqPedido,qryDescProd: TFDQuery;
begin
  qryPesqPedido  := RodarSelect('select * from pedidos_produtos where num_pedido = '+ Trim(edtCodPedido.text));
  qryPesqPedido.Open;
  cdsPedido.EmptyDataSet;
  qryPesqPedido.First;
  while not qryPesqPedido.Eof do
   Begin
     cdsPedido.Append;
     cdsPedido.FieldByName('codProd').AsInteger:=qryPesqPedido.FieldByName('cod_produto').AsInteger;
     //pesquisaproduto(edCodigo.Text);
     qryDescProd:=RodarSelect('Select descricao from produtos where codigo='+Trim(qryPesqPedido.FieldByName('cod_produto').AsString));
     cdsPedido.FieldByName('produto').AsString:=qryDescProd.FieldByName('descricao').AsString;
     cdsPedido.FieldByName('quant').AsInteger:=qryPesqPedido.FieldByName('quant').AsInteger;
     cdsPedido.FieldByName('prunit').AsFloat:=qryPesqPedido.FieldByName('vlr_unitario').AsFloat;
     cdsPedido.FieldByName('prtot').AsFloat:=qryPesqPedido.FieldByName('vlr_total').AsFloat;
     cdsPedido.Post;
     calculaGrid;
     qryPesqPedido.Next;
   End;
end;

procedure TForm2.Button1Click(Sender: TObject);
var
 npedido: integer;
begin

  npedido:=InserirPedidoResumo(now,StrToInt(Trim(edCliente.text)),StrToFloat(Trim(edtvaltot.text)));
  cdsPedido.First;
  while not cdsPedido.Eof do
    Begin
      stbRodape.Panels[1].Text:=InserirPedidoProd(npedido,cdsPedidocodProd.Value,cdsPedidoquant.value,cdsPedidoprunit.value,cdsPedidoprtot.Value);
      cdsPedido.Next;

    End;
  LimpaGrid;
end;

procedure TForm2.CalculaGrid;
begin
  cdsPedido.First;
  cValtot:=0;
  while not cdsPedido.Eof do
   begin
     cValtot:=cValtot+cdsPedido.FieldByName('prtot').AsFloat;
     edtValTot.Text:=FloatToStr(cValtot);
     cdsPedido.Next;
   end;
   grdPedido.Refresh;
end;

procedure TForm2.edClienteChange(Sender: TObject);
begin
 if edCliente.Text='' then
     Begin
     btnPesqPedido.Enabled:=True;
     btnCancela.Enabled:=True;
   End
 else
   Begin
     btnPesqPedido.Enabled:=False;
     btnCancela.Enabled:=False;
   End;

end;

procedure TForm2.edQuantExit(Sender: TObject);
begin
 edPunit.Text:= PesqPunitProduto(Trim(edCodigo.Text));// qryPesquisa.FieldByName('preco_venda').AsString;
end;

procedure TForm2.FormCreate(Sender: TObject);
var
 ini: TIniFile;
 vHost,vPort,vDB,vUser,vPass :String;
begin
 cdsPedido.CreateDataSet;
 conexao;

end;

procedure TForm2.FormShow(Sender: TObject);
begin
 cdsPedido.Open;
 cValtot:=0;
 if edCliente.Text='' then
   Begin
     btnPesqPedido.Enabled:=True;
     btnCancela.Enabled:=True;
   End
 else
   Begin
     btnPesqPedido.Enabled:=False;
     btnCancela.Enabled:=False;
   End;

end;

procedure TForm2.grdPedidoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then
    Begin
      edCodigo.Text:=IntToStr(cdsPedidocodProd.Value);
      edQuant.Text:=IntToStr(cdsPedidoquant.Value);
      edPunit.Text:=FloatToStr(cdsPedidoprunit.Value);
      op:='E';
    End;
  if key=VK_DELETE then
    Begin
      if not cdsPedido.IsEmpty then
        Begin
          if messagedlg('Deseja excluir o registro selecionado?',mtconfirmation,[mbyes,mbno],0) = mryes then
           begin
             cdsPedido.Delete;
             CalculaGrid;
           end;
        End;
    End;
end;



procedure TForm2.LimpaCampos;
begin
  edCodigo.Clear;
  edQuant.Clear;
  edPunit.Clear;
end;

procedure TForm2.LimpaGrid;
begin
  cdsPedido.EmptyDataSet;
end;

procedure TForm2.PesquisaProduto(cod: string);
var
 qryPesquisa: TFDQuery;
begin
 qryPesquisa:= TFDQuery.Create(nil);
 qryPesquisa.Connection:= fdcConexao;
 qryPesquisa.Close;
 qryPesquisa.SQL.Clear;
 qryPesquisa.SQL.Add('Select codigo,descricao,preco_venda from produtos where codigo = '+ cod);
 qryPesquisa.Open;
 qryPesquisa.Free;

end;

end.
