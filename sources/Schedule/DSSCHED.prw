#INCLUDE "PROTHEUS.CH"

#DEFINE PERGUNTE "DSSCHED"

//-----------------------------------------------------------
/*/{Protheus.doc} DsSched
	Fonte Fake para simular uma tarefa / agendamento no schedule
	@type function
	@version 1.0
	@author Danilo Salve
	@since 15/12/2023
/*/
//-----------------------------------------------------------
function DsSched()
	ConsoleMsg()
	updateA1LC()
return

//-----------------------------------------------------------
/*/{Protheus.doc} updateA1LC
	Incrementa 1 no limite de cr�dito do Cliente.
	@type function
	@version 1.0
	@author Danilo Salve
	@since 16/06/2025
/*/
//-----------------------------------------------------------
static function updateA1LC()
	Local aArea as array
	Local cCodCliDe as character
	Local cCodCliAte as character
	Local cFilSA1 as character
	Local cLojaDe as character
	Local cLojaAte as character

	aArea := FwGetArea()
	cFilSA1 := FwXFilial("SA1")

	cCodCliDe := iif(type("MV_PAR03") == "C", MV_PAR03, '')
	cLojaDe := iif(type("MV_PAR04") == "C", MV_PAR04, '')
	cCodCliAte := iif(type("MV_PAR05") == "C", MV_PAR05, '')
	cLojaAte := iif(type("MV_PAR06") == "C", MV_PAR06, '')

	DbSelectArea("SA1")
	SA1->(DbSetOrder(1)) // A1_FILIAL, A1_COD, A1_LOJA
	SA1->(DbSeek(cFilSA1 + cCodCliDe + cLojaDe))

	While !SA1->(Eof()) .and. SA1->A1_FILIAL == cFilSA1 .and.;
	 SA1->A1_COD >= cCodCliDe .and. SA1->A1_COD <= cCodCliAte .and. SA1->A1_LOJA >= cLojaDe .and. SA1->A1_LOJA <= cLojaAte

	 	If RecLock("SA1", .f.)
			SA1->A1_LC := SA1->A1_LC + 1
		EndIf

		SA1->(DbSkip())
	EndDo

	SA1->(DbCloseArea())
	FwRestArea(aArea)
return 

//-----------------------------------------------------------
/*/{Protheus.doc} ConsoleMsg
	Adiciona uma mensagem de Log
	@type function
	@version 1.0
	@author Danilo Salve
	@since 16/06/2025
/*/
//-----------------------------------------------------------
static function ConsoleMsg()
	local cLog as character
    local lLog as logical

    lLog := iif(type("MV_PAR01") == "N", MV_PAR01 == 1, .f.)
    cLog := iif(type("MV_PAR02") == "C", MV_PAR02, '')

    conOut(CRLF + " #################################### ")
	conOut(" ############ DSSCHED ############### ")
	conOut(" ############ " + Time() + " ############## ")
	conOut(" #### EMPRESA : " + cEmpAnt + " ################## ")
	conOut(" #### FILIAL : " + cFilAnt + " ############# ")
	conOut(" #### USUARIO : " + __cUserId + " ############ ")
	conOut(" #################################### ")
	conOut(" #### DATA : " + DTOC(Date()) + " ############### ")

    If lLog .and. !Empty(cLog)
	    conOut(" #################################### ")
	    conOut(" ########## MESSAGEM DE LOG ######### ")
	    conOut(" ## " + cLog + " ## ")
	    conOut(" ########## FIM MSG DE LOG ########## ")
	    conOut(" #################################### ")
    Endif

	conOut(" #################################### " + CRLF)
return nil

//-----------------------------------------------------------
/*/{Protheus.doc} Scheddef
	Fun��o estatica com a configura��es do Schedule
	@type function
	@version 1.0
	@author Danilo Salve
	@since 15/12/2023
	@return array, Par�metros do schedule
/*/
//-----------------------------------------------------------
static function Scheddef() as array
	local aParam as array
	
	aParam := { "P",;			//Tipo R para relatorio P para processo
        PERGUNTE,;		//Pergunte do relatorio, caso nao use passar ParamDef
        ,;				//Alias
        ,;				//Array de ordens
	}
return aParam
