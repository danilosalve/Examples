#INCLUDE "PROTHEUS.CH"

//-----------------------------------------------------------
/*/{Protheus.doc} DsSched
	Fonte Fake para simular uma tarefa / agendamento no schedule - Sem SchedDef
	@type function
	@version 1.0
	@author Danilo Salve
	@since 15/12/2023
    @param aParams, array, Array contendo (Empresa, Filial, Id do Usuário, Id do Agendamento)
/*/
//-----------------------------------------------------------
main function DsSched2(aParams as array)
    default aParams := {"T1", "D MG 01", "000002", ""}

    RpcSetEnv( aParams[1], aParams[2], aParams[3], /*cEnvPass*/, /*cEnvMod*/, "DSSCHED2"/*cFunName - Se não informado usa RPC*/)
	ConsoleMsg(aParams[4])
	updateA1LC()
    RpcClearEnv()
return

//-----------------------------------------------------------
/*/{Protheus.doc} updateA1LC
	Incrementa 1 no limite de crédito do Cliente.
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

	cCodCliDe := "000002"
	cLojaDe := "01"
	cCodCliAte := "000004"
	cLojaAte := "zz"

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
    @param cAgendId, character, Identificador do Agendamento
/*/
//-----------------------------------------------------------
static function ConsoleMsg(cAgendId as character)
    conOut(CRLF + " #################################### ")
	conOut(" ############ DSSCHED ############### ")
	conOut(" ############ " + Time() + " ############## ")
	conOut(" #### EMPRESA : " + cEmpAnt + " ################## ")
	conOut(" #### FILIAL : " + cFilAnt + " ############# ")
	conOut(" #### USUARIO : " + __cUserId + " ############ ")
	conOut(" #### AGENDAMENTO : " + cAgendId + " ####### ")
	conOut(" #################################### ")
	conOut(" #### DATA : " + DTOC(Date()) + " ############### ")
	conOut(" #################################### " + CRLF)
return nil
