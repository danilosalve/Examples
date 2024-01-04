#INCLUDE "PROTHEUS.CH"

#DEFINE PERGUNTE "DSSCHED"

//-----------------------------------------------------------
/*/{Protheus.doc} DSSCHED
Fonte Fake para simular uma tarefa / agendamento no schedule
@type function
@version 1.0
@author Danilo Salve
@since 15/12/2023
/*/
//-----------------------------------------------------------
Function DSSCHED()
    local cLog as character
    local lLog as logical

    //Pergunte( PERGUNTE, .f. )    
    lLog := iif(type("MV_PAR01") == "N", MV_PAR01 == 1, .f.)
    cLog := iif(type("MV_PAR02") == "C", MV_PAR02, '')

    conOut(CRLF + " #################################### ")
	conOut(" ############ DSSCHED ############### ")
	conOut(" ############ " + Time() + " ############## ")
	conOut(" #### EMPRESA : " + cEmpAnt + " ################## ")
	conOut(" #### FILIAL : " + cFilAnt + " ############# ")	

    If lLog
	    conOut(" #################################### ")
	    conOut(" ########## MESSAGEM DE LOG ######### ")
	    conOut( cLog )
	    conOut(" ########## FIM MSG DE LOG ########## ")
	    conOut(" #################################### ")
    Endif

	conOut(" #################################### " + CRLF)
return 

//-----------------------------------------------------------
/*/{Protheus.doc} Scheddef
Função estatica com a configurações do Schedule
@type function
@version 1.0
@author Danilo Salve
@since 15/12/2023
@return array, Parâmetros do schedule
/*/
//-----------------------------------------------------------
static Function Scheddef() as array
	local aParam as array
	
	aParam := { "P",;			//Tipo R para relatorio P para processo
        PERGUNTE,;		//Pergunte do relatorio, caso nao use passar ParamDef
        ,;				//Alias
        ,;				//Array de ordens
	}
return aParam
