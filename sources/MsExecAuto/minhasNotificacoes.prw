#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

//------------------------------------------------------------------
/*/{Protheus.doc} MyNotify
    Exemplo de grava��o de uma notifica��o
    @author 	Danilo Salve
    @since 		30/06/2022
    @version 	1.0
    @return     logical, Retorna se o processo foi executado com sucesso.
/*/
//-------------------------------------------------------------------
user function MyNotify()
    local aMsgErro := {}
	local lRet := .f.
	lOCAL oModel := FWLoadModel("TGVA001")
	lOCAL oModelA1S := oModel:GetModel("A1SMASTER")
    local nI := 0

	oModel:SetOperation(MODEL_OPERATION_INSERT)
	oModel:Activate()

	if oModel:IsActive()
		oModelA1S:SetValue("A1S_TITULO", "MINHAS NOTIFICA��O")
		oModelA1S:SetValue("A1S_DESC"	, "INCLUINDO UMA NOTIFICA��O PERSONALIZADA")
		oModelA1S:SetValue("A1S_TIPO"	, "1") // 1 - Pedido de Venda, 2 - Cadastro de Cliente e 3 - Or�amento de Venda
		oModelA1S:SetValue("A1S_CODUSR"	, "000000")
		oModelA1S:SetValue("A1S_STATUS"	, "1") // 1 - N�o Visualizada e 2 - Visualizada
		oModelA1S:SetValue("A1S_MOV"	, 7) 
        /*
            7 - Inclus�o de Pedido com Sucesso, 8 - Altera��o de Pedido com Sucesso, 9 - Exclus�o de Pedido com Sucesso
            11 - Inclus�o de Or�amento com Sucesso, 12 - Altera��o de Or�amento com Sucesso, 13 - Exclus�o de Or�amento com Sucesso
        */
		If oModel:VldData() .And. oModel:CommitData()
			lRet := .T.
		Else
			lRet := .F.
            aMsgErro := oModel:GetErrorMessage()        
            For nI := 1 To Len(aMsgErro)
                If ValType(aMsgErro[nI]) == "C"
                    Conout(StrTran( StrTran( aMsgErro[nI], "<", "" ), "-", "" ) + (" "))
                EndIf
            Next nI
		EndIf
	endIf

    oModel:DeActivate()
	FreeObj(oModelA1S)
	FreeObj(oModel)
    aSize(aMsgErro, 0)
return lRet
