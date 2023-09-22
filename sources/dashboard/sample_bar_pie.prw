#INCLUDE "TOTVS.CH"
#INCLUDE "RESTFUL.CH"
  
//------------------------------------------------------------------------
/*/{Protheus.doc} Exemplo3
    Exemplo de API de integração de Graficos de Barra e Linha
  
    @author     Squad CRM & Faturamento
    @since      28/07/2020
    @version    12.1.27
/*/
//------------------------------------------------------------------------
WSRESTFUL Exemplo3 DESCRIPTION "Exemplo de API - Grafico Barra e Linha"
    WSDATA JsonFilter       AS STRING     OPTIONAL
    WSDATA drillDownFilter  AS STRING     OPTIONAL
    WSDATA Fields           AS STRING     OPTIONAL
    WSDATA Order            AS STRING     OPTIONAL
    WSDATA Page             AS INTEGER  OPTIONAL
    WSDATA PageSize         AS INTEGER  OPTIONAL
  
    WSMETHOD GET form ;
        DESCRIPTION "Formulario de Cadastro do Gráfico" ;
        WSSYNTAX "/charts/form/" ;
        PATH "/charts/form";
        PRODUCES APPLICATION_JSON
  
    WSMETHOD POST retDados ;
        DESCRIPTION "Deverá retornar as informações apresentadas no gráfico." ;
        WSSYNTAX "/charts/retDados/{JsonFilter}" ;
        PATH "/charts/retDados";
        PRODUCES APPLICATION_JSON
  
    WSMETHOD POST itemsDetails ;
        DESCRIPTION "Carrega o detalhamento do gráfico" ;
        WSSYNTAX "/charts/itemsDetails/{JsonFilter}" ;
        PATH "/charts/itemsDetails";
        PRODUCES APPLICATION_JSON
  
ENDWSRESTFUL
  
//-------------------------------------------------------------------
/*/{Protheus.doc} GET form
  Retorna os campos que serão apresentados no formulário.
  O padrão do campo deve seguir o Dynamic Form do Portinari.
  
  @author Squad CRM & Faturamento
  @since 27/03/2020
  @version Protheus 12.1.27
/*/
//-------------------------------------------------------------------
WSMETHOD GET form WSSERVICE Exemplo3
  
    Local oResponse   := JsonObject():New()
    Local oCoreDash   := CoreDash():New()
  
    oCoreDash:SetPOForm("Tipo de Gráfico", "charttype"       , 6, "Tipo de Gráfico"        , .T., "string" , oCoreDash:SetPOCombo({{"line","Linha"}, {"bar","Barra"}}))
    oCoreDash:SetPOForm("Filtros"        , "dateIni"         , 6, "Data Inicial"           , .T., 'date'   , , .T.)
    oCoreDash:SetPOForm(""               , "dateFim"         , 6, "Data Final"             , .T., 'date'   , , .T.)
    oCoreDash:SetPOForm(""               , "person"          , 6, "Pessoa"                 , .F., 'string' , oCoreDash:SetPOCombo({{"F","Física"}  , {"J","Jurídica"}}), .T.)
    oCoreDash:SetPOForm(""               , "blocked"         , 6, "Bloqueado?"             , .F., 'string' , oCoreDash:SetPOCombo({{"1","Sim"}     , {"2","Não"}})     , .F.)
  
    oResponse  := oCoreDash:GetPOForm()
  
    Self:SetResponse( EncodeUtf8(oResponse:ToJson()))
  
Return .T.
  
//-------------------------------------------------------------------
/*/{Protheus.doc} POST retDados
  Retorna os dados do Gráfico
  
  @author Squad CRM & Faturamento
  @since 27/03/2020
  @version Protheus 12.1.27
/*/
//-------------------------------------------------------------------
WSMETHOD POST retDados WSRECEIVE JsonFilter WSSERVICE Exemplo3
  
    Local oResponse   := JsonObject():New()
    Local oCoreDash   := CoreDash():New()
    Local oJson       := JsonObject():New()
  
    oJson:FromJson(DecodeUtf8(Self:GetContent()))
  
    retDados(@oResponse, oCoreDash, oJson)
  
    Self:SetResponse( EncodeUtf8(oResponse:ToJson()))
  
    oResponse := Nil
    FreeObj( oResponse )
  
    oCoreDash:Destroy()
    FreeObj( oCoreDash )
  
Return .T.
  
//-------------------------------------------------------------------
/*/{Protheus.doc} Function retDados
  Retorna o valor das Meta e o Valor Vendido de acordo com parâmetros
  informados
  
  @author Squad CRM & Faturamento
  @since 16/05/2022
  @version Protheus 12.1.33
/*/
//-------------------------------------------------------------------
Static Function retDados(oResponse, oCoreDash, oJson)
    Local aData    := {}
    Local aDataFim := {}
    Local aData1   := {}
    Local aData2   := {}
    Local aData3   := {}
    Local aData4   := {}
    Local aData5   := {}
    Local aCab     := {}
    Local aCores    := oCoreDash:GetColorChart()
    Local aSaldo   := {}
    Local nSaldo   := 0
    Local cPessoa  := ""
    Local cFiltros := ""
    Local nFilter  := 0
    Local nCntFilt := 0
  
    If oJson:GetJsonText("level") == "null" .Or. Len(oJson["level"]) == 0
        aCab := {'SP', 'RJ', 'MG' }

        //######### Obter os filtros do cadastro ou de usuário e aplicar na query #########
        
        // Filtro por tipo da pessoa - Com Multi-seleção
        If oJson:HasProperty("person") .And. ValType(oJson["person"]) == "A"
          cPessoa := oJson["person"]
          nCntFilt := Len(oJson["person"])
          For nFilter := 1 To nCntFilt
            If nFilter == 1
              cFiltros += " AND ("
            Else
              cFiltros += " OR "
            EndIf
            
            cFiltros += "SA1.A1_PESSOA = '" + oJson["person"][nFilter] + "' "

            If nFilter == nCntFilt
              cFiltros += ") "
            EndIf
          Next
        EndIf

        // Filtro por tipo da pessoa - com uma única seleção
        If oJson:HasProperty("blocked") .And. ValType(oJson["blocked"]) == "C"
          cFiltros += "AND SA1.A1_MSBLQL = '" + oJson["blocked"] + "'"
        EndIf

        //######### Fim da obtenção os filtros do cadastro ou de usuário e aplicar na query #########
        
        aData1 := { RetRisco(cFiltros + " AND SA1.A1_RISCO = 'A' AND SA1.A1_EST = 'SP'"), RetRisco(cFiltros + " AND SA1.A1_RISCO = 'A' AND SA1.A1_EST = 'RJ'"), RetRisco(cFiltros + " AND SA1.A1_RISCO = 'A' AND SA1.A1_EST = 'MG'") }
        aData2 := { RetRisco(cFiltros + " AND SA1.A1_RISCO = 'B' AND SA1.A1_EST = 'SP'"), RetRisco(cFiltros + " AND SA1.A1_RISCO = 'B' AND SA1.A1_EST = 'RJ'"), RetRisco(cFiltros + " AND SA1.A1_RISCO = 'B' AND SA1.A1_EST = 'MG'") }
        aData3 := { RetRisco(cFiltros + " AND SA1.A1_RISCO = 'C' AND SA1.A1_EST = 'SP'"), RetRisco(cFiltros + " AND SA1.A1_RISCO = 'C' AND SA1.A1_EST = 'RJ'"), RetRisco(cFiltros + " AND SA1.A1_RISCO = 'C' AND SA1.A1_EST = 'MG'") }
        aData4 := { RetRisco(cFiltros + " AND SA1.A1_RISCO = 'D' AND SA1.A1_EST = 'SP'"), RetRisco(cFiltros + " AND SA1.A1_RISCO = 'D' AND SA1.A1_EST = 'RJ'"), RetRisco(cFiltros + " AND SA1.A1_RISCO = 'D' AND SA1.A1_EST = 'MG'") }
  
        oCoreDash:SetChartInfo( aData1, 'Risco A', , aCores[8][3] ) //Cor utilizada: OrangeLht
        oCoreDash:SetChartInfo( aData2, 'Risco B', , aCores[1][3] ) //Cor utilizada: GreenDk
        oCoreDash:SetChartInfo( aData3, 'Risco C', , aCores[6][3] ) //Cor utilizada: YellowDk
        oCoreDash:SetChartInfo( aData4, 'Risco D', , aCores[15][3] ) //Cor utilizada: BrowDk
  
        nSaldo := (aData1[1] + aData2[1] + aData3[1] + aData4[1] ) / 4
        aAdd(aSaldo, nSaldo)
        nSaldo := (aData1[2] + aData2[2] + aData3[2] + aData4[2] ) / 4
        aAdd(aSaldo, nSaldo)
        nSaldo := (aData1[3] + aData2[3] + aData3[3] + aData4[3] ) / 4
        aAdd(aSaldo, nSaldo)
  
        oCoreDash:SetChartInfo( aSaldo, 'Média', "line", aCores[9][3] ,,.F.) //Cor utilizada: BlueDk     
  
        aDataFim := {}
        aAdd(aDataFim, oCoreDash:SetChart(aCab,,.F., ,"Quantidade de Clientes por Risco em cada Estado"))
    ElseIf Len(oJson["level"]) == 1
        aCab := {'Semana 1', 'Semana 2', 'Semana 3', 'Semana 4' }
  
        aData1          := { Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 )}
        aData2          := { Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 )}
        aData3          := { Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 )}
        aData4          := { Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 )}
        aData5          := { Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 ), Randomize( 100000000.00, 999000000.00 )}
  
        oCoreDash:SetChartInfo( aData1, '00000101 - Cliente 000001',,aCores[8][3] ) //Cor utilizada: OrangeLht
        oCoreDash:SetChartInfo( aData2, '00000102 - Cliente 000002',,aCores[1][3] ) //Cor utilizada: GreenDk
        oCoreDash:SetChartInfo( aData3, '00543501 - Cliente 000003',,aCores[6][3] ) //Cor utilizada: YellowDk
        oCoreDash:SetChartInfo( aData4, '00543502 - Cliente 000004',,aCores[15][3] ) //Cor utilizada: BrowDk
        oCoreDash:SetChartInfo( aData5, '00543503 - Cliente 000005',,aCores[10][3] ) //Cor utilizada: BlueLht
  
        aDataFim := {}
        aAdd(aDataFim, oCoreDash:SetChart(aCab,,.T., ,"Maiores Vendas - " + oJson["level"][1]["labelDataSet"] + " - " + oJson["level"][1]["label"]))
    ElseIf Len(oJson["level"]) == 2
        aCab := {"Pedido - 234323", "Pedido - 234322", "Pedido - 234456", "Pedido - 234533", "Pedido - 234222" }

        oData       := JsonObject():New()
  
        aData   := { 26589, 25000,23560,10000,35000}
  
        aDataFim := {}
        aAdd(aDataFim, oCoreDash:SetChart(aCab, aData, .T.,"pie", "Maiores Clientes - " + oJson["level"][2]["labelDataSet"] + " - " + oJson["level"][1]["label"]))
    EndIf
    oResponse["items"] := aDataFim
  
Return
  
//-------------------------------------------------------------------
/*/{Protheus.doc} POST itemsDetails
  Método para retornar os dados do Painel
  
  @author Squad CRM & Faturamento
  @since 27/03/2020
  @version Protheus 12.1.27
/*/
//-------------------------------------------------------------------
WSMETHOD POST itemsDetails WSRECEIVE JsonFilter, drillDownFilter WSRESTFUL Exemplo3
  
  Local aHeader     := {}
  Local aItems      := {}
  Local aRet        := {}
  Local cBody       := DecodeUtf8(Self:GetContent())
  Local cError        := "Erro na Requisição"
  Local lRet              := .T.
  Local oCoreDash   := CoreDash():New()
  Local oBody       := JsonObject():New()
  Local oJsonFilter := JsonObject():New()
  Local oJsonDD     := JsonObject():New()
  
  If !Empty(cBody)
    oBody:FromJson(cBody)
    If ValType(oBody["chartFilter"]) == "J"
        oJsonFilter := oBody["chartFilter"]
    EndIf
    If ValType(oBody["detailFilter"]) == "A"
        oJsonDD := oBody["detailFilter"]
    EndIf
  EndIf
  
  Self:SetContentType("application/json")
  //Verifico o Nivel do grafico
  If oJsonFilter:GetJsonText("level") == "null" .Or. Len(oJsonFilter["level"]) == 0
    //Verifico o nivel do Drilldpwn
    If Len(oJsonDD) == 0
      aHeader := {;
          {"codigo"     , "Código"        ,"link"               },;
          {"nome"         , "Nome Vendedor"                       },;
          {"totalItens" , "Total de Itens","number",'1.2-5',.F. },;
          {"totalValor" , "Valor Total"   , "currency","BRL",.F.};
          }
  
      aItems := {;
          {"codigo"     , "SA3.A3_COD"    },;
          {"nome"         , "SA3.A3_NOME"   },;
          {"totalItens" , "QTDITEM"       },;
          {"totalValor" , "TOTAL","N"     };
          }
  
      aRet := MntQuery1()
    ElseIf Len(oJsonDD) == 1
      //Caso eu queira pegar o nome do nível selecionado : oJsonFilter["level"][1]["labelDataSet"]
      // Se fosse gráfico do tipo pizza: oJsonFilter["level"][1]["label"]
      aHeader := {;
          {"codigoPed"  , "Código do Pedido"    },;
          {"codigoCli"  , "Código do Cliente"   },;
          {"nome"         , "Nome"                },;
          {"totalValor" , "TOTAL","currency","BRL",.F.};
          }
  
      aItems := {;
          {"codigoPed"  , "SC5.C5_NUM"   },;
          {"codigoCli"  , "SC5.C5_CLIENTE"  },;
          {"nome"       , "SA1.A1_NOME"      },;
          {"totalValor" , "TOTAL","N"        };
          }
      aRet := MntQuery2("SC5.C5_VEND1 = '" + oJsonDD[1]["codigo"] + "'")
    EndIf
  ElseIf Len(oJsonFilter["level"]) == 1
    aHeader := {;
          {"codigoPed"  , "Código do Pedido"    },;
          {"codigoCli"  , "Código do Cliente"   },;
          {"nome"         , "Nome"                },;
          {"totalValor" , "TOTAL","currency","BRL",.F.};
          }
  
      aItems := {;
          {"codigoPed"  , "SC5.C5_NUM"   },;
          {"codigoCli"  , "SC5.C5_CLIENTE"  },;
          {"nome"       , "SA1.A1_NOME"      },;
          {"totalValor" , "TOTAL","N"        };
          }
      aRet := MntQuery2("SA1.A1_RISCO = '" + Right(oJsonFilter["level"][1]["labelDataSet"],1) + "' AND SA1.A1_EST = '" + oJsonFilter["level"][1]["label"] + "' ")
  ElseIf Len(oJsonFilter["level"]) == 2
    aHeader := {;
        {"codigo"     , "Código"        },;
        {"nome"       , "Nome Vendedor" },;
        {"totalItens" , "Total de Itens","number",'1.2-5',.F.},;
        {"totalValor" , "Valor Total", "currency","BRL",.F.};
        }
  
    aItems := {;
        {"codigo"     , "SA3.A3_COD"   },;
        {"nome"       , "SA3.A3_NOME"  },;
        {"totalItens" , "QTDITEM"      },;
        {"totalValor" , "TOTAL","N" };
        }
  
    aRet := MntQuery1()
  EndIf
  
  oCoreDash:SetQuery(aRet[1])
  oCoreDash:SetWhere(aRet[2])
  oCoreDash:SetGroupBy(aRet[3])
  oCoreDash:SetFields(aItems)
  oCoreDash:SetApiQstring(Self:aQueryString)
  oCoreDash:BuildJson()
  
  If lRet
    oCoreDash:SetPOHeader(aHeader)
    Self:SetResponse( oCoreDash:ToObjectJson() )
  Else
    cError := oCoreDash:GetJsonError()
    SetRestFault( 500,  EncodeUtf8(cError) )
  EndIf
  
  oCoreDash:Destroy()
  
  FreeObj(oBody)
  FreeObj(oJsonFilter)
  FreeObj(oJsonDD)
  FreeObj(oCoreDash)
  
  aSize(aRet, 0)
  aSize(aItems, 0)
  aSize(aHeader, 0)
  
Return( lRet )
  
//-------------------------------------------------------------------
/*/{Protheus.doc} MntQuery1
  Monta a Query o Total dos Pedidos de Venda
  
  @author Squad CRM & Faturamento
  @since 27/03/2020
  @version Protheus 12.1.27
/*/
//-------------------------------------------------------------------
Static Function MntQuery1()
  Local cQuery  := ""
  Local cWhere  := ""
  Local cGroup  := ""
    
  cQuery := " SELECT SA3.A3_COD, SA3.A3_NOME, COUNT(C6_ITEM) QTDITEM, SUM(C6_VALOR) TOTAL "
  cQuery += " FROM " + RetSqlName("SC5") + " SC5 "
  
  cQuery += " INNER JOIN " + RetSqlName("SC6") + " SC6 ON SC6.C6_NUM = SC5.C5_NUM "
  cQuery += " INNER JOIN " + RetSqlName("SA3") + " SA3 ON SA3.A3_COD = SC5.C5_VEND1 "
  
  cWhere := " SC5.D_E_L_E_T_ = ' ' "
  cWhere += " AND SC6.D_E_L_E_T_ = ' ' "
  cWhere += " AND SA3.D_E_L_E_T_ = ' ' "
  cWhere += " AND SC5.C5_FILIAL = '" + xFilial("SC5") + "'   "
  cWhere += " AND SC6.C6_FILIAL = '" + xFilial("SC6") + "'   "
  cWhere += " AND SA3.A3_FILIAL = '" + xFilial("SA3") + "'   "
  cWhere += " AND SC5.C5_EMISSAO >= '20220401'   "
  
  cGroup := " SA3.A3_COD, SA3.A3_NOME "
  
Return {cQuery, cWhere, cGroup}
  
//-------------------------------------------------------------------
/*/{Protheus.doc} MntQuery2
  Monta Query do Pedido de vendas realizando um filtro específo.
  
  @author Squad CRM & Faturamento
  @since 27/03/2020
  @version Protheus 12.1.27
/*/
//-------------------------------------------------------------------
Static Function MntQuery2(cFilter)
  Local cQuery  := ""
  Local cGroup  := ""
  Local cWhere  := ""
  
  Default cFilter := ""
  
  cQuery := " SELECT SC5.C5_NUM, SC5.C5_CLIENTE, SA1.A1_NOME, SUM(C6_VALOR) TOTAL "
  cQuery += " FROM " + RetSqlName("SC5") + " SC5 "
  cQuery += " INNER JOIN " + RetSqlName("SC6") + " SC6 ON SC6.C6_NUM = SC5.C5_NUM "
  cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON SA1.A1_COD = SC5.C5_CLIENTE
  
  if !Empty(cFilter)
      cWhere += cFilter + " AND "
  EndIf
  
  cWhere += " SC5.D_E_L_E_T_ = ' ' "
  cWhere += " AND SC6.D_E_L_E_T_ = ' ' "
  cWhere += " AND SA1.D_E_L_E_T_ = ' ' "
  cWhere += " AND SC5.C5_FILIAL = '" + xFilial("SC5") + "'   "
  cWhere += " AND SC6.C6_FILIAL = '" + xFilial("SC6") + "'   "
  cWhere += " AND SA1.A1_FILIAL = '" + xFilial("SA1") + "'   "
  cWhere += " AND SC5.C5_EMISSAO >= '20220401'   "  // Limite adicionado para evitar lentidao no retorno da query em bases com uma quantidade muito grande de pedidos de vendas
  
  cGroup := " C5_NUM, C5_CLIENTE, SA1.A1_NOME "
  
Return {cQuery, cWhere, cGroup}
 
//-------------------------------------------------------------------
/*/{Protheus.doc} RetRisco
    Retorna o total de clientes de acordo com o risco informado no
    filtro
   
    @param cFiltro, Caractere, Filtro a ser adicionado na query
    @author Squad CRM & Faturamento
    @since 13/04/2022
    @version 12.1.33
/*/
//-------------------------------------------------------------------
Static Function RetRisco(cFiltro)
    Local aQuery  := MntQuery3("COUNT(SA1.A1_COD) TOTAL_REGISTROS", cFiltro)
    Local cQuery  := ""
    Local cTemp   := GetNextAlias()
    Local xRet 
  
    Default cWhere  := ""
    Default cInfo   := ""
  
    cQuery := aQuery[1] + " WHERE " + aQuery[2]
  
    DBUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), cTemp, .T., .T. )
  
    xRet := (cTemp)->TOTAL_REGISTROS
  
    (cTemp)->( DBCloseArea() )
Return xRet
 
//-------------------------------------------------------------------
/*/{Protheus.doc} MntQuery3
    Monta a query responsável por trazer os clientes de acordo com o
    risco informado no filtro
   
    @param cCampos,  Caractere, Campos que serão retornados no SELECT
    @param cFiltro,  Caractere, Filtro a ser adicionado na query
    @param cGroupBy, Caractere, Expressão group by a ser adicionada na query
    @author Squad CRM & Faturamento
    @since 13/04/2022
    @version 12.1.33
/*/
//-------------------------------------------------------------------
Static Function MntQuery3(cCampos, cFiltro, cGroupBy)
    Local cQuery
    Local cWhere
    Local cGroup
  
    Default cTable := "SA1"
    Default cCampos := "SA1.A1_COD, SA1.A1_LOJA, SA1.A1_NOME, SA1.A1_NREDUZ, SA1.A1_RISCO"
   
    cQuery := " SELECT " + cCampos + " FROM " + RetSqlName("SA1") + " SA1 "
    cWhere := " SA1.A1_FILIAL = '" + xFilial("SA1") + "'" + cFiltro
    cWhere += " AND SA1.D_E_L_E_T_ = ' ' "
  
    If !Empty(cGroupBy)
        cGroup := cGroupBy
    EndIf
Return {cQuery, cWhere, cGroup}
