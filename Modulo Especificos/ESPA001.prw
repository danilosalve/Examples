#INCLUDE "Protheus.ch"
#INCLUDE "FWMVCDEF.CH"

#Define STRESP001 OemToAnsi("Casos de Teste")
#Define STRESP002 OemToAnsi("Casos de Teste Automatizados")

//-------------------------------------------------------------------
/*/{Protheus.doc} ESPA001
    Rotina para cadastro de Casos de TEste

    @param		Nenhum
    @return     Nulo
    @author 	Squad CRM & Faturamento
    @version	12.1.23
    @since		05/04/2019
/*/
//-------------------------------------------------------------------
Function ESPA001()

    Local oMBrowse	:= Nil

    Private aRotina		:= MenuDef()

    oMBrowse:= BrowseDef()
	oMBrowse:Activate()

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} BrowseDef
Configurações do browse de Casos de Teste
@param		Nenhum
@return	    oMBrowse, FWMBrowse, Browse da Rotina

@author 	Squad CRM & Faturamento
@version	12.1.23
@since		05/04/2019
/*/
//-------------------------------------------------------------------
Static Function BrowseDef()

    Local oMBrowse 	:= Nil
    Local oTableAtt := Nil

    oMBrowse := FWMBrowse():New()
	oMBrowse:SetAlias("SZA")
	oMBrowse:SetDescription( OemToAnsi( STRESP001 ))  //"Casos de Teste"
	oMBrowse:SetMenuDef("ESPA001")
    oMBrowse:SetTotalDefault("ZA_COD","COUNT",OemToAnsi("Total de Registros"))
    
    oMBrowse:AddLegend("ZA_MSBLQL == '1'"                       ,"RED"    ,OemToAnsi("Inativo"))
    oMBrowse:AddLegend("ZA_STATUS == 'A' .And. ZA_MSBLQL == '2'","GREEN"  ,OemToAnsi("Automatizado"))
    oMBrowse:AddLegend("ZA_STATUS == 'O' .And. ZA_MSBLQL == '2'","BLACK"  ,OemToAnsi("Obsoleto"))
    oMBrowse:AddLegend("ZA_STATUS == 'R' .And. ZA_MSBLQL == '2'","YELLOW" ,OemToAnsi("Rascunho"))
    oMBrowse:AddLegend("ZA_STATUS == 'V' .And. ZA_MSBLQL == '2'","ORANGE" ,OemToAnsi("Revisar"))
    
    oTableAtt := TableAttDef()
	oMBrowse:SetAttach( .T. )
	oMBrowse:SetViewsDefault( oTableAtt:aViews )
    oMBrowse:SetChartsDefault( oTableAtt:aCharts )
    oMBrowse:SetIDChartDefault( "CTs" )
    
Return oMBrowse

//------------------------------------------------------------------------------
/*/	{Protheus.doc} TableAttDef
Cria as vis?s e graficos

@param		Nenhum
@return	    oTableAtt, Objeto,  Objetos com as Visoes e Graicos.
@author 	Squad CRM & Faturamento
@version	12.1.23
@since      05/04/2019
/*/
//------------------------------------------------------------------------------
Static Function TableAttDef()

    Local oAutomat	:= Nil 
    Local oGrafico  := Nil 
    Local oTableAtt := FWTableAtt():New()

    oTableAtt:SetAlias("SZA")

    // Casos de Teste Automatizados
    oAutomat := FWDSView():New()
    oAutomat:SetName(STRESP002) //"Casos de Teste Automatizados"
    oAutomat:SetID(OemToAnsi("Automatizados"))
    oAutomat:SetOrder(1) 
    oAutomat:SetCollumns({"ZA_COD", "ZA_PROG", "ZA_DESC"})
    oAutomat:SetPublic( .T. )
    oAutomat:AddFilter(STRESP002, "ZA_STATUS == 'A'") //"Casos de Teste Automatizados"
    oTableAtt:AddView(oAutomat)

    // Grafico - Pizza
    oGrafico := FWDSChart():New()
    oGrafico:SetName( STRESP001 ) 
    oGrafico:SetTitle( "CTs x Status" )
    oGrafico:SetID( "PorStatus" )
    oGrafico:SetType( "PIECHART" )
    oGrafico:SetSeries( { {"SZA", "ZA_STATUS", "COUNT"} } )
    oGrafico:SetCategory( { {"SZA", "ZA_STATUS"} } )
    oGrafico:SetPublic( .T. )
    oGrafico:SetLegend( CONTROL_ALIGN_LEFT )
    oGrafico:SetTitleAlign( CONTROL_ALIGN_CENTER )
    oTableAtt:AddChart( oGrafico )

Return oTableAtt

//-------------------------------------------------------------------
/*/{Protheus.doc} MenuDef
Menu do cadastro de Casos de Teste

@param		Nenhum
@return	    aRotina,    Array,  Rotinas do Menu
@author 	Squad CRM & Faturamento
@version	12.1.23
@since		05/04/2019
/*/
//-------------------------------------------------------------------
Static Function Menudef()

    Local aRotina   := {}
    
    ADD OPTION aRotina TITLE OemToAnsi("Pesquisar"  ) ACTION "PesqBrw"          OPERATION 1 ACCESS 0 
	ADD OPTION aRotina TITLE OemToAnsi("Visualizar" ) ACTION "VIEWDEF.ESPA001"  OPERATION 2	ACCESS 0 
	ADD OPTION aRotina TITLE OemToAnsi("Incluir"	) ACTION "VIEWDEF.ESPA001"  OPERATION 3	ACCESS 0 
	ADD OPTION aRotina TITLE OemToAnsi("Alterar"	) ACTION "VIEWDEF.ESPA001"  OPERATION 4 ACCESS 0 
	ADD OPTION aRotina TITLE OemToAnsi("Excluir"	) ACTION "VIEWDEF.ESPA001"  OPERATION 5 ACCESS 0 
	ADD OPTION aRotina TITLE OemToAnsi("Imprimir"	) ACTION "VIEWDEF.ESPA001"  OPERATION 8 ACCESS 0
	ADD OPTION aRotina TITLE OemToAnsi("Copiar"	    ) ACTION "VIEWDEF.ESPA001"  OPERATION 9 ACCESS 0

Return aRotina

//-------------------------------------------------------------------
/*/{Protheus.doc} ModelDef
Modelo de dados de Casos de Teste

@param		Nenhum
@return	    oModel,    Objeto,  Model da Tabela SZA
@author 	Squad CRM & Faturamento
@version	12.1.23
@since      05/04/2019
/*/
//-------------------------------------------------------------------

Static Function ModelDef()

	Local oModel        := Nil
	Local oStructSZA    := FWFormStruct(1,"SZA")
    Local bTudoOk       := {|oModel|ESP001TOK(oModel)}
	
	//oModel:= MPFormModel():New( 'ModelSZA', ,{ |oModel| AFIN22TOK( oModel ) } )
    oModel := MPFormModel():New("ESPA001",/*bPreValid*/,bTudoOk,/*bCommit*/,/*bCancel*/)
	oModel:AddFields("SZAMASTER",/*cOwner*/,oStructSZA,/*bPreValid*/,/*bPosValid*/,/*bCarga*/)
    oModel:SetPrimaryKey({"ZA_FILIAL" ,"ZA_PROG", "ZA_COD"})
    oModel:SetDescription(STRESP001)//"Casos de Teste"
	
Return oModel

//-------------------------------------------------------------------
/*/{Protheus.doc} ViewDef
Interface do modelo de dados de Casos de Teste

@param		Nenhum
@return	    oModel,    Objeto,  Model da Tabela SZA
@author 	Squad CRM & Faturamento
@version	12.1.23
@since      05/04/2019
/*/
//-------------------------------------------------------------------

Static Function ViewDef()

	Local oView         := Nil
	Local oModel        := FWLoadModel("ESPA001")	
    Local oStructSZA    := FWFormStruct(2,"SZA",/*bAvalCampo*/,/*lViewUsado*/)

	oView := FWFormView():New()	
	oView:SetModel(oModel)
    oView:AddField("VIEW_SZA",oStructSZA,"SZAMASTER")
    oView:CreateHorizontalBox("BOXFORMSZA",100)	
    oView:SetOwnerView("VIEW_SZA","BOXFORMSZA")
	
Return oView


//-------------------------------------------------------------------
/*/{Protheus.doc} ESP001TOK
Funcao para chamar a validação (TudoOk) do formulario

@param		Nenhum
@return	    lRet,    Logico, Retorna o formulario é valido
@author 	Squad CRM & Faturamento
@version	12.1.23
@since      05/04/2019
/*/
//-------------------------------------------------------------------
Static Function ESP001TOK(oModel)

    Local lRet  := .T.
    
    If oModel:GetOperation() == MODEL_OPERATION_INSERT
        If SZA->(MsSeek(xFilial("SZA") + M->ZA_PROG + M->ZA_COD))            
            Help('',1,OemToAnsi("EXISTCT"),,OemToAnsi("Não pode haver mais de um registro de Caso de Teste com o mesmo Programa e Codigo. Verifique o conteúdo destes campos") + oModel:GetValue("DA1_ITEM"),1,0)
            lRet  := .F.
        Endif
    Endif

Return lRet