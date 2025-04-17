#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
//-----------------------------------------------------------
/*/{Protheus.doc} DSJSON
Exemplo de utilização de objeto Json
@author     Danilo Salve
@since      26/10/2018
@version    1.1
@Example    DSJSON()
/*/
//-------------------------------------------------------------
Function DSJSON()
    //Exemplo 1 -> Cria um JSON
    CriaJson()
    //Exemplo 2  -> Converte String em JSON
    ConvJson()

Return Nil


Static Function CriaJson()
    Local oJson     := JsonObject():new()
    Local oJsonName := JsonObject():new()
    Local oJsonCar  := JsonObject():new()

    oJsonName["FirstName"]  := "Bruce"
    oJsonName["LastName"]   := "Waine"
    oJsonName["Nick"]       := "Batman"
    oJson['Name'] := {}
    aAdd(oJson["Name"], oJsonName)
    oJson["Car"] := {}
    oJsonCar["Name"]  := "Batmovel"
    aAdd(oJson["Car"], oJsonCar)
    //ToJSON -> Converte Objeto JSON em String
    Conout(oJson:ToJSON())

    FreeObj(oJson)
Return Nil

Static Function ConvJson()
    Local oJson := JsonObject():new()
    
    oJson:fromJson('{"name":"John", "age":31, "city":"New York"}')
    //ToJSON -> Converte Objeto JSON em String
    Conout(oJson:ToJSON())

    FreeObj(oJson)
Return Nil
