#INCLUDE "protheus.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"

User Function DSTeste()

	PREPARE ENVIRONMENT EMPRESA "T1" FILIAL "D MG 01 " MODULO "CRM"
	DCRM180I() 	//Inclui
	DCRM180A()	//Altera
	DCRM180E()	//Altera
	RESET ENVIRONMENT
	
Return Nil

/*
INCLUI COMPROMISSO
*/

Static Function  DCRM180I()

	Local aErro	:= {}
	Local oModel  := FWLoadModel("CRMA180")
	
	CONOUT("Inicio inclusão:" + Time())
	
	//Define Operacao de inclusao
	oModel:SetOperation(MODEL_OPERATION_INSERT)
	oModel:Activate()
	//Utilizar Field do oModel (addField)	
	oModel:SetValue("AOFMASTER","AOF_ASSUNT","Teste Inclusao ExecAuto")
	oModel:SetValue("AOFMASTER","AOF_TIPO"	,"2")
	oModel:SetValue("AOFMASTER","AOF_DTINIC",dDatabase)
	oModel:SetValue("AOFMASTER","AOF_HRINIC",Subst(Time(),1,5))
	oModel:SetValue("AOFMASTER","AOF_DTFIM"	,dDatabase + 1)
	oModel:SetValue("AOFMASTER","AOF_HRFIM",StrTran(CValToChar(SOMAHORAS(Time(),"01:15:00")),".",":"))
	oModel:SetValue("AOFMASTER","AOF_PERCEN","1")
	oModel:SetValue("AOFMASTER","AOF_STATUS","1")
	oModel:SetValue("AOFMASTER","AOF_CODUSR","000003")
	
	If oModel:VldData()
		oModel:CommitData()
	Else
		//Captura erro
		aErro	:= oModel:GetErrorMessage()
		//Gera Erro
		AutoGrLog( "Id do campo de erro: " 		+ AllToChar( aErro[4] ))
		AutoGrLog( "Id do erro: " 				+ AllToChar( aErro[5] ))
		AutoGrLog( "Mensagem do erro: " 		+ AllToChar( aErro[6] ))
		AutoGrLog( "Mensagem da solução: " 		+ AllToChar( aErro[7] ))
		AutoGrLog( "Valor atribuído: " 			+ AllToChar( aErro[8] ))
		AutoGrLog( "Valor anterior: " 			+ AllToChar( aErro[9] ))
		//Exibe erro para usuario
		MostraErro()		
	EndIf
	
	CONOUT("Fim inclusão:" + Time())
	
	oModel:DeActivate()
	//Limpa da memoria objeto e Limpa Array
	FreeObj(oModel)
	aSize(aErro,0)

Return Nil

Static Function  DCRM180A()

	Local aErro	:= {}
	Local oModel  := FWLoadModel("CRMA180")
	
	CONOUT("Inicio Alteracao:" + Time())
	
	DbSelectArea("AOF")
	AOF->(DbSetOrder(1)) //AOF_FILIAL, AOF_CODIGO
	If AOF->(DbSeek(xFilial("AOF") + "000008"))
	
		//Define Operacao de inclusao
		oModel:SetOperation(MODEL_OPERATION_UPDATE)
		oModel:Activate()
		//Utilizar Field do oModel (addField)	
		oModel:SetValue("AOFMASTER","AOF_HRINIC",Subst(Time(),1,5))
		oModel:SetValue("AOFMASTER","AOF_HRFIM",StrTran(CValToChar(SOMAHORAS(Time(),"01:15:00")),".",":"))	
		If oModel:VldData()
			oModel:CommitData()
		Else
			//Captura erro
			aErro	:= oModel:GetErrorMessage()
			//Gera Erro
			AutoGrLog( "Id do campo de erro: " 		+ AllToChar( aErro[4] ))
			AutoGrLog( "Id do erro: " 				+ AllToChar( aErro[5] ))
			AutoGrLog( "Mensagem do erro: " 		+ AllToChar( aErro[6] ))
			AutoGrLog( "Mensagem da solução: " 		+ AllToChar( aErro[7] ))
			AutoGrLog( "Valor atribuído: " 			+ AllToChar( aErro[8] ))
			AutoGrLog( "Valor anterior: " 			+ AllToChar( aErro[9] ))
			//Exibe erro para usuario
			MostraErro()		
		EndIf
		
		CONOUT("Fim Alteracao:" + Time())
		
		oModel:DeActivate()
		//Limpa da memoria objeto e Limpa Array
		FreeObj(oModel)
		aSize(aErro,0)
	
	Endif

Return Nil

Static Function  DCRM180E()

	Local aErro	:= {}
	Local oModel  := FWLoadModel("CRMA180")
	
	CONOUT("Inicio Exclusao:" + Time())
	
	DbSelectArea("AOF")
	AOF->(DbSetOrder(1)) //AOF_FILIAL, AOF_CODIGO
	If AOF->(DbSeek(xFilial("AOF") + "000009"))
	
		//Define Operacao de inclusao
		oModel:SetOperation(MODEL_OPERATION_DELETE)
		oModel:Activate()

		If oModel:VldData()
			oModel:CommitData()
		Else
			//Captura erro
			aErro	:= oModel:GetErrorMessage()
			//Gera Erro
			AutoGrLog( "Id do campo de erro: " 		+ AllToChar( aErro[4] ))
			AutoGrLog( "Id do erro: " 				+ AllToChar( aErro[5] ))
			AutoGrLog( "Mensagem do erro: " 		+ AllToChar( aErro[6] ))
			AutoGrLog( "Mensagem da solução: " 		+ AllToChar( aErro[7] ))
			AutoGrLog( "Valor atribuído: " 			+ AllToChar( aErro[8] ))
			AutoGrLog( "Valor anterior: " 			+ AllToChar( aErro[9] ))
			//Exibe erro para usuario
			MostraErro()		
		EndIf
		
		CONOUT("Fim Exclusao:" + Time())
		
		oModel:DeActivate()
		//Limpa da memoria objeto e Limpa Array
		FreeObj(oModel)
		aSize(aErro,0)
	
	Endif

Return Nil