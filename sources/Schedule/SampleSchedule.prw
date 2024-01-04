#include "protheus.ch"

//-----------------------------------------------------------
/*/{Protheus.doc} relSchdP
Fonte Fake para simular uma tarefa / agendamento no schedule
@type function
@version 1.0
@author Danilo Salve
@since 07/11/2023
/*/
//-----------------------------------------------------------
user function relSchdP()
	conOut(CRLF + " ##################################### ")
	conOut(" ############ relSchdP ############### ")
	conOut(" ############ " + Time() + " ############### ")
	conOut(" ##################################### ")
	conOut(" ##################################### " + CRLF)
return nil

//-----------------------------------------------------------
/*/{Protheus.doc} relSchdP
Fonte Fake para simular uma tarefa / agendamento no schedule
@type function
@version 1.0
@author Danilo Salve
@since 07/11/2023
/*/
//-----------------------------------------------------------
user function relSchdB()
	conOut(CRLF + " ##################################### ")
	conOut(" ############ relSchd - 2 ############ ")
	conOut(" ############ " + Time() + " ############### ")
	conOut(" ##################################### ")
	conOut(" ##################################### " + CRLF)
return nil


//-----------------------------------------------------------
/*/{Protheus.doc} Scheddef
Fun��o estatica com a configura��es do Schedule
@type function
@version 1.0
@author Danilo Salve
@since 07/11/2023
@return array, Par�metros do schedule
/*/
//-----------------------------------------------------------
static Function Scheddef() as array
	local aParam as array
	//aParam := { "R", "MTA330", /*Alias*/, /*Ord*/, ""}
	aParam := { "P",;			//Tipo R para relatorio P para processo
        "PARAMDEF",;		//Pergunte do relatorio, caso nao use passar ParamDef
        ,;				//Alias
        ,;				//Array de ordens
	}
return aParam
