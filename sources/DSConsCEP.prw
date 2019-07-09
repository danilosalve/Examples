#Include "Protheus.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} DSbubble
    Executa a consulta de um CEP atravez de um WS

    @param		cCep,   Caractere   , Codigo Postal - CEP  
    @return     oRet,   Objeto      , Objeto JSON com Endereco
    @author 	Danilo Salve
    @version	12.1.25
    @since		09/07/2019
/*/
//-------------------------------------------------------------------
Function DSConsCEP( cCep )

    Local cURL      := "http://viacep.com.br/ws"
    Local oRestCli  := Nil
    Local oRet      := Nil

    Default cCep := "00000000"

    cCep := StrZero(Val(StrTran( cCep, "-", "" )),8)
    oRestCli := FWRest():New( cUrl )    
    oRestCli:setPath( "/" + cCep + "/json/")

    If oRestCli:Get()
        oRet := oRestCli:GetResult()
        ConOut( oRet )
    Else
        Conout( oRestCli:GetLastError() )
    Endif

    FreeObj( oRestCli )

Return oRet