object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 535
  ClientWidth = 752
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object GroupBox1: TGroupBox
    Left = 8
    Top = 138
    Width = 744
    Height = 457
    Caption = 'Produtos'
    TabOrder = 0
    object grdPedido: TDBGrid
      Left = -4
      Top = 20
      Width = 741
      Height = 300
      DataSource = dsPedido
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnKeyDown = grdPedidoKeyDown
      Columns = <
        item
          Expanded = False
          FieldName = 'codProd'
          Title.Caption = 'C'#243'digo'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'produto'
          Title.Caption = 'Produto'
          Width = 300
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'quant'
          Title.Caption = 'Quantidade'
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'prunit'
          Title.Caption = 'Pre'#231'o Unit'#225'rio'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'prtot'
          Title.Caption = 'Pre'#231'o Total'
          Width = 120
          Visible = True
        end>
    end
    object Panel3: TPanel
      Left = -8
      Top = 320
      Width = 877
      Height = 47
      TabOrder = 1
      object Label6: TLabel
        Left = 347
        Top = 14
        Width = 54
        Height = 15
        Caption = 'Valor Total'
      end
      object edtValTot: TEdit
        Left = 414
        Top = 5
        Width = 102
        Height = 38
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -21
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
      object Button1: TButton
        Left = 530
        Top = 12
        Width = 94
        Height = 25
        Caption = 'Gravar Pedido'
        TabOrder = 1
        OnClick = Button1Click
      end
      object btnFim: TButton
        Left = 651
        Top = 12
        Width = 94
        Height = 25
        Caption = 'Fim'
        TabOrder = 2
        OnClick = btnFimClick
      end
    end
  end
  object stbRodape: TStatusBar
    Left = 0
    Top = 516
    Width = 752
    Height = 19
    Color = clHotLight
    Panels = <
      item
        Text = 'Mensagens'
        Width = 100
      end
      item
        Width = 50
      end>
    ExplicitTop = 515
    ExplicitWidth = 748
  end
  object Panel2: TPanel
    Left = 8
    Top = 15
    Width = 744
    Height = 47
    TabOrder = 2
    object Label5: TLabel
      Left = 21
      Top = 14
      Width = 65
      Height = 15
      Caption = 'C'#243'd. Cliente'
    end
    object Label7: TLabel
      Left = 172
      Top = 14
      Width = 65
      Height = 15
      Caption = 'Cod. Pedido'
    end
    object edCliente: TEdit
      Left = 97
      Top = 10
      Width = 52
      Height = 23
      TabOrder = 0
      OnChange = edClienteChange
    end
    object edtCodPedido: TEdit
      Left = 255
      Top = 10
      Width = 70
      Height = 23
      TabOrder = 1
    end
    object btnPesqPedido: TButton
      Left = 504
      Top = 9
      Width = 111
      Height = 25
      Caption = 'Pesquisar Pedido'
      TabOrder = 2
      OnClick = btnPesqPedidoClick
    end
    object btnCancela: TButton
      Left = 621
      Top = 9
      Width = 98
      Height = 25
      BiDiMode = bdLeftToRight
      Caption = 'Cancelar Pedido'
      ParentBiDiMode = False
      TabOrder = 3
      OnClick = btnCancelaClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 68
    Width = 744
    Height = 72
    Caption = 'Inserir / Alterar Registros'
    TabOrder = 3
    object Label9: TLabel
      Left = 21
      Top = 31
      Width = 71
      Height = 15
      Caption = 'C'#243'd. Produto'
    end
    object Label10: TLabel
      Left = 173
      Top = 31
      Width = 62
      Height = 15
      Caption = 'Quantidade'
    end
    object Label11: TLabel
      Left = 331
      Top = 31
      Width = 75
      Height = 15
      Caption = 'Pre'#231'o Unit'#225'rio'
    end
    object edCodigo: TEdit
      Left = 102
      Top = 28
      Width = 52
      Height = 23
      TabOrder = 0
    end
    object edQuant: TEdit
      Left = 244
      Top = 28
      Width = 57
      Height = 23
      TabOrder = 1
      OnExit = edQuantExit
    end
    object edPunit: TEdit
      Left = 422
      Top = 28
      Width = 121
      Height = 23
      TabOrder = 2
    end
    object btnInsert: TButton
      Left = 650
      Top = 27
      Width = 75
      Height = 25
      Caption = 'OK'
      TabOrder = 3
      OnClick = btnInsertClick
    end
  end
  object dsPedido: TDataSource
    DataSet = cdsPedido
    Left = 488
    Top = 208
  end
  object cdsPedido: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 488
    Top = 272
    object cdsPedidocodProd: TIntegerField
      FieldName = 'codProd'
    end
    object cdsPedidoproduto: TStringField
      FieldName = 'produto'
      Size = 35
    end
    object cdsPedidoquant: TIntegerField
      FieldName = 'quant'
    end
    object cdsPedidoprunit: TCurrencyField
      FieldName = 'prunit'
    end
    object cdsPedidoprtot: TCurrencyField
      FieldName = 'prtot'
    end
  end
  object fdcConexao: TFDConnection
    Params.Strings = (
      'DriverID=MySQL'
      'User_Name=root')
    LoginPrompt = False
    Transaction = FDTransaction1
    Left = 648
    Top = 320
  end
  object FDTransaction1: TFDTransaction
    Connection = fdcConexao
    Left = 680
    Top = 176
  end
  object qryPesqPedido: TFDQuery
    Connection = fdcConexao
    Left = 608
    Top = 248
  end
end
