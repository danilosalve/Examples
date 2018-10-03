#Include "PROTHEUS.CH"

/*/{Protheus.doc} DSRestTest
Exemplo de Classe Client de REST 
@author     Danilo Salve
@since      01/10/2018
@version    1.0
@Example    U_DSRestTest
Url: http://tdn.totvs.com/display/framework/FWRest
/*/

User Function DSRestTest()

    Local aHeadStr    := {}
    Local cUrl      := "http://localhost:8082"
    Local oRestCli  := Nil

    oRestCli := FWRest():New(cUrl)
    
    aadd(aHeadStr,'Content-Type: application/json')
    aadd(aHeadStr,'Authorization: Basic YWRtaW46MQ==')

    oRestCli:setPath("/paymentcondition/fat/paymentcondition/D+MG+01+000")

    If oRestCli:Get(aHeadStr)
        ConOut(oRestCli:GetResult())
    Else
        conout(oRestCli:GetLastError())
    Endif

Return Nil
