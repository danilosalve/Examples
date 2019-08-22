#INCLUDE "PROTHEUS.CH"
#INCLUDE "PARMTYPE.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} SC9Adapter
	Classe Adapter para o serviço
	@author  Danilo Salve
	@since   22/08/2019
	@version 1.0
/*/
//-------------------------------------------------------------------

CLASS SC9Adapter FROM FWAdapterBaseV2

	METHOD New()
	METHOD GetListPvLb()

EndClass

//-------------------------------------------------------------------
/*/{Protheus.doc} New
	Método construtor	
	@param 		cVerbo, 	caractere,	verbo HTTP utilizado
	@author  	Danilo Salve
	@since   	22/08/2019
	@version 	1.0
/*/
//-------------------------------------------------------------------
Method New( cVerbo ) CLASS SC9Adapter

	_Super:New( cVerbo, .T. )

Return

//-------------------------------------------------------------------
/*/{Protheus.doc} GetListPvLb
	Método que retorna uma lista de produtos
	@author  Danilo Salve
	@since   22/08/2019
	@version 1.0
/*/
//-------------------------------------------------------------------
Method GetListPvLb() CLASS SC9Adapter

	Local aArea 	AS ARRAY
	Local cWhere	AS CHAR

	aArea   := GetArea()

	//Adiciona o mapa de campos Json/ResultSet
	AddMapFields( self )

	//Informa a Query a ser utilizada pela API
	::SetQuery( GetQuery() )

	//Informa a clausula Where da Query
	cWhere := " C9_FILIAL = '"+ xFilial("SC9") +"' AND SC9.D_E_L_E_T_ <> '*'"
	cWhere += " AND C9_NFISCAL = '" + Space(TamSX3("C9_NFISCAL")[1]) + "'"
	cWhere += " AND C9_SERIENF = '" + Space(TamSX3("C9_SERIENF")[1]) + "'"
	cWhere += " AND ( C9_BLEST = '10' OR C9_BLEST = '"+ Space(TamSX3("C9_BLEST")[1])  + "')"
	cWhere += " AND ( C9_BLCRED = '10' OR C9_BLCRED = '"+ Space(TamSX3("C9_BLCRED")[1])  + "')"	
	
	::SetWhere( cWhere )

	//Informa a ordenação a ser Utilizada pela Query
	::SetOrder( SqlOrder( SC9->( IndexKey(1) ) ) )	

	//Executa a consulta, se retornar .T. tudo ocorreu conforme esperado
	If ::Execute() 
		// Gera o arquivo Json com o retorno da Query
		// Pode ser reescrita, iremos ver em outro artigo de como fazer
		::FillGetResponse()
	EndIf

	RestArea( aArea )
	aSize( aArea, 0 )

Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} AddMapFields
	Função para geração do mapa de campos
	@param 		oSelf, 		object, 	Objeto da própria classe
	@author  Danilo Salve
	@since   22/08/2019
	@version 1.0
/*/
//-------------------------------------------------------------------
Static Function AddMapFields( oSelf )
	//oSelf:AddMapFields( cFieldJson	, cFieldQuery, 	lJsonField, lFixed, aStruct )
	//aStruc := Vetor com a estrutura do campo no padrão {“CAMPO”, “TIPO”, Tamanho, Decimal
	oSelf:AddMapFields( "BRANCH"    , "C9_FILIAL" 	, .T., .T., { "C9_FILIAL"	, 'C', TamSX3( "C9_FILIAL"	)[1], 0 } )
	oSelf:AddMapFields( "CODE"	    , "C9_PEDIDO" 	, .T., .F., { "C9_PEDIDO"	, 'C', TamSX3( "C9_PEDIDO"	)[1], 0 } )	
	oSelf:AddMapFields( "ITEM"		, "C9_ITEM"		, .T., .F., { "C9_ITEM"		, 'C', TamSX3( "C9_ITEM" 	)[1], 0 } )
	oSelf:AddMapFields( "SEQUENCE"	, "C9_SEQUEN"	, .T., .F., { "C9_SEQUEN"	, 'C', TamSX3( "C9_SEQUEN"  )[1], 0 } )
	oSelf:AddMapFields( "PRODUCT"	, "C9_PRODUTO"	, .T., .F., { "C9_PRODUTO"	, 'C', TamSX3( "C9_PRODUTO" )[1], 0 } )

Return Nil


//-------------------------------------------------------------------
/*/{Protheus.doc} GetQuery
	Retorna a query usada no serviço	
	@param 		oSelf, 		object, 	Objeto da própria classe
	@author  	Danilo Salve
	@since   	22/08/2019
	@version 	1.0
/*/
//-------------------------------------------------------------------
Static Function GetQuery()

	Local cQuery AS CHARACTER
	
	cQuery := " SELECT #QueryFields#"
    cQuery += " FROM " + RetSqlName( "SC9" ) + " SC9 "
    cQuery += " WHERE #QueryWhere#"
	
Return cQuery