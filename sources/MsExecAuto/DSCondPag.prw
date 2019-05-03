#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "TBICONN.CH"

//------------------------------------------------------------------
/*/{Protheus.doc} ExecMVC()
Inclusao de Condicao de Pagamento Utilizando MVC

@author 	danilo.salve
@since 		19/02/2019
@version 	12.1.23
@return 	Nulo
/*/
//-------------------------------------------------------------------

User Function DSCondPag()

    Local aErro	:= {}
	Local oModel  := Nil

    //PREPARE ENVIRONMENT EMPRESA "T1" FILIAL "D MG 01 " MODULO "FAT"	

    oModel := FWLoadModel("MATA360")
	
	//Define Operacao de inclusao
	oModel:SetOperation(MODEL_OPERATION_INSERT)
	oModel:Activate()
	//Utilizar Field do oModel (addField)
	oModel:SetValue("SE4MASTER","E4_CODIGO" ,"501")
    oModel:SetValue("SE4MASTER","E4_TIPO"   ,"1")
    oModel:SetValue("SE4MASTER","E4_COND"   ,"20,45,60")
    oModel:SetValue("SE4MASTER","E4_DESCRI" ,"DSCONDPAG")
    oModel:SetValue("SE4MASTER","E4_MSBLQL" ,"2")
    oModel:SetValue("SE4MASTER","E4_AGRACRS","1")
    oModel:SetValue("SE4MASTER","E4_CCORREN","2")

	If oModel:VldData()
		oModel:CommitData()
        Conout("Dados importados com sucesso!!!")
	Else
		//Captura erro
		aErro	:= oModel:GetErrorMessage()
		//imprime erro no console
		Conout( "Id do campo de erro: " + AllToChar( aErro[4] ))
		Conout( "Id do erro: " 			+ AllToChar( aErro[5] ))
		Conout( "Mensagem do erro: " 	+ AllToChar( aErro[6] ))
		Conout( "Mensagem da solução: "	+ AllToChar( aErro[7] ))
		Conout( "Valor atribuído: " 	+ AllToChar( aErro[8] ))
		Conout( "Valor anterior: " 		+ AllToChar( aErro[9] ))			
	EndIf
	
	oModel:DeActivate()

	FreeObj(oModel)

	aSize(aErro,0)
    aErro := {}

    //RESET ENVIRONMENT

Return Nil