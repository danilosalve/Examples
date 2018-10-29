#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
//-----------------------------------------------------------
/*/{Protheus.doc} DSJSON
Exemplo de utilização de objeto Json
@author     Danilo Salve
@since      26/10/2018
@version    1.0
@Example    U_DSJSON
/*/
//-------------------------------------------------------------
User Function DSJSON()
    PREPARE ENVIRONMENT EMPRESA "T1" FILIAL "D MG 01 " MODULO "FAT"
    Teste()
	RESET ENVIRONMENT

Return Nil

Static Function Teste()

    Local oJson1    := JsonObject():new()
    Local cEncode64 := Encode64(,"C:\\Protheus\\P12.LG\\protheus_data\\dirdoc\\cot1\\shared\\piada.jpg",.F.,.F.)

    oJson1['FirstName']  := 'Danilo'
    oJson1['LastName']   := 'Salve'
    oJson1['Encode64']   := cEncode64

Return Nil

