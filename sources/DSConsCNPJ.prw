#Include "Protheus.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} DSConsCNPJ
    Executa a consulta de um CEP atravez de um WS

    @param		cCnpj,   Caractere   , CNPJ 
    @return     oRet ,   Objeto      , Objeto JSON com Endereco
    @author 	Danilo Salve
    @version	12.1.25
    @since		08/08/2019
    @see        https://receitaws.com.br/api
/*/
//-------------------------------------------------------------------
Function DSConsCNPJ( cCnpj )
    
    Local cURL      := "https://www.receitaws.com.br/v1/cnpj/"    
    Local oRestCli  := Nil
    Local oRet      := Nil   

    Default cCnpj := "00000000000000"

    cCnpj := StrZero( Val( StrTran(StrTran(StrTran( cCnpj,".",""),"-",""),"/","") ), 14 )
    oRestCli := FWRest():New( cUrl )
    oRestCli:setPath( cCnpj )

    If oRestCli:Get()        
        oRet := JsonObject():New()
        oRet:fromJson( DecodeUtf8( oRestCli:GetResult() ) )        
    Else
        Conout( oRestCli:GetLastError() )
    Endif

    FreeObj( oRestCli )

Return oRet