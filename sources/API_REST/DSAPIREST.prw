#INCLUDE "PROTHEUS.CH"
#INCLUDE "RESTFUL.CH"

//Dummy Function
Function DSAPIREST()

Return .T.

//-------------------------------------------------------------------
/*/{Protheus.doc} DSAPIREST
	Declara��o do ws DSAPIREST

	@author 	Danilo Salve
	@since 		22/08/2019
	@version 	1.0

/*/
//-------------------------------------------------------------------
WSRESTFUL DSAPIREST DESCRIPTION "Endpoint products API" FORMAT "application/json,text/html"

    WSDATA Fields			AS STRING	OPTIONAL
	WSDATA Order			AS STRING	OPTIONAL
	WSDATA Page				AS INTEGER	OPTIONAL
	WSDATA PageSize			AS INTEGER	OPTIONAL
	WSDATA aQueryString		AS ARRAY	OPTIONAL
    
 	WSMETHOD GET PedVendaLb;
	    DESCRIPTION "Retorna uma lista de Itens de Pedido de Vendas liberados";
	    WSSYNTAX "/api/v1/dsapirest" ;
        PATH "/api/v1/dsapirest" ;
	    PRODUCES APPLICATION_JSON
 	
END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} GET dsapirest
	M�todo GET PedVendaLb - Retorna uma lista de Itens de Pedido de Vendas liberados
	
	@param		Order,		caractere,	order da tabela principal
	@param		Page,		Numerico,	N�mero da pagina consultada
	@param		PageSize,	Numerico,	Numero de registros da p�gina
	@param		Fields,		caractere,	Campos utilizados no retorno da requisi��o
	@author 	Danilo Salve
	@since 		22/08/2019
	@version 	1.0

	@examples  {{URL}}/api/v1/dsapirest?PageSize=2&Page=2&Code=pcp935

/*/
//-------------------------------------------------------------------
WSMETHOD GET PedVendaLb WSRECEIVE QUERYPARAM, Order, Page, PageSize, Fields WSSERVICE dsapirest
Return GetPvLbLst(self)

//-------------------------------------------------------------------
/*/{Protheus.doc} GET GetPvLbLst
Fun��o para tratamento da requisi��o GET

	@author 	Danilo Salve
	@since 		22/08/2019
	@version 	1.0
/*/
//-------------------------------------------------------------------
Static Function GetPvLbLst( oWS )

   Local lRet  		as Logical
   Local oPedVenda 	as Object

   Default oWS:Page := 1  
   Default oWs:PageSize := 10   

   oPedVenda := SC9Adapter():new( "GET" )
  
   oPedVenda:setPage(oWS:Page)
   oPedVenda:setPageSize(oWs:PageSize)
   oPedVenda:SetUrlFilter( oWS:aQueryString )

   oPedVenda:GetListPvLb()

	If oPedVenda:lOk
		oWS:SetResponse(oPedVenda:getJSONResponse())
		lRet := .T.
	Else
		SetRestFault(oPedVenda:GetCode(),oPedVenda:GetMessage())
		lRet := .F.
	EndIf

   oPedVenda:DeActivate()
   FreeObj(oPedVenda)
   
Return lRet
