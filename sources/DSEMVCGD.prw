#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FWMVCDEF.CH"

/*/{Protheus.doc} DSEMVCGD
Exemplo de ExecAuto MVC com Grid
@author		Danilo Salve
@since		22/10/2018
@version	12.1.23
/*/

User Function DSEMVCGD()

	PREPARE ENVIRONMENT EMPRESA "T1" FILIAL "D MG 01 " MODULO "FAT"

	DSFAT310(.T.,.F.,.F.,2)

	DbSelectArea("AD5")
	DbSelectArea("AD6")
	AD5->(DbGoTo(107))
	DSFAT310(.F.,.T.,.F.,2)

	DSDELALL()


	RESET ENVIRONMENT
		
Return Nil

/*/{Protheus.doc} DSFAT310
Exemplo de ExecAuto MVC com Grid
@author		Danilo Salve
@since		22/10/2018
@version	12.1.23
/*/

Static Function DSFAT310(lInclui , lAltera , lExclui , nItem)
	Local aErro		:= {}
	Local lRet		:= .T.
	Local nI		:= 0
	Local oModel  	:= FWLoadModel("FATA310")
	Local oModelDtl	:= oModel:GetModel("AD6DETAIL")

	Default lInclui	:= .F.
	Default lAltera	:= .F.
	Default lExclui	:= .F.
	Default nItem	:= 0

	ConOut(Repl("-",80))
	ConOut("Inicio: "+Time())
	If lInclui		
		ConOut(PadC("Teste de Inclusao de apontamento de venda com 2 itens ",80))
		oModel:SetOperation(MODEL_OPERATION_INSERT)
	Elseif lAltera		
		ConOut(PadC("Teste de Alteracao",80))
		oModel:SetOperation(MODEL_OPERATION_UPDATE)
	Elseif lExclui		
		ConOut(PadC("Teste de Exclusao ",80))
		oModel:SetOperation(MODEL_OPERATION_DELETE)
	Else
		lRet := .F.
	Endif

	ConOut(Repl("-",80))

	If lRet
		If oModel:Activate()

			oModel:SetValue("AD5MASTER","AD5_FILIAL","D MG 01 ")
			oModel:SetValue("AD5MASTER","AD5_VEND"	,"000003")
			oModel:SetValue("AD5MASTER","AD5_SEQUEN","02")
			oModel:SetValue("AD5MASTER","AD5_DATA"	,CTOD("22/10/2018"))
			oModel:SetValue("AD5MASTER","AD5_CODCLI","000008")
			oModel:SetValue("AD5MASTER","AD5_LOJA"	,"01")
			oModel:SetValue("AD5MASTER","AD5_NROPOR","002024")
			oModel:SetValue("AD5MASTER","AD5_EVENTO","000001")

			While nI < oModelDtl:GetQTDLine() .or. oModelDtl:Length(.T.) <> nItem
				nI++
				ConOut(CValtoChar(nI))

				If oModelDtl:GetQTDLine() < nItem .And. nI == nItem
					oModelDtl:AddLine()
				Elseif oModelDtl:GetQTDLine() > nItem 
					oModelDtl:GoLine(nI)
					oModelDtl:DeleteLine()
					Loop
				Else
					oModelDtl:GoLine(nI)
				Endif

				oModelDtl:SetValue("AD6_ITEM"	,StrZero(nI,2))
				oModelDtl:SetValue("AD6_CODPRO"	,"PROD00001")
				oModelDtl:SetValue("AD6_VLUNIT"	,100)
				oModelDtl:SetValue("AD6_QUANT"	,2)

			Enddo

			If oModel:VldData()
				oModel:CommitData()
				ConOut("Operacao realizada com sucesso !!!")
			Else
				//Captura erro
				aErro	:= oModel:GetErrorMessage()
				//Gera Erro
				ConOut( "Id do campo de erro: " 		+ AllToChar( aErro[4] ))
				ConOut( "Id do erro: " 					+ AllToChar( aErro[5] ))
				ConOut( "Mensagem do erro: " 			+ AllToChar( aErro[6] ))
				ConOut( "Mensagem da solu��o: " 		+ AllToChar( aErro[7] ))
				ConOut( "Valor atribu�do: " 			+ AllToChar( aErro[8] ))
				ConOut( "Valor anterior: " 				+ AllToChar( aErro[9] ))
			EndIf

		Endif
	Endif

	ConOut(Repl("-",80))
	ConOut("Fim: "+Time())
	ConOut(Repl("-",80))

Return lRet


Static Function DSDELALL()
	Local aCabec	:= {}
	Private aRotina			:= FWMVCMenu( 'FATA310' )

	DbSelectArea("AD5")
	AD5->(DbGoTop())

	While !(AD5->(Eof()))

		aadd(aCabec,{"AD5_FILIAL" ,AD5->AD5_FILIAL	,Nil}) 
		aadd(aCabec,{"AD5_VEND"   ,AD5->AD5_VEND	,Nil})
		aadd(aCabec,{"AD5_DATA"   ,AD5->AD5_DATA	,Nil})
		aadd(aCabec,{"AD5_SEQUEN" ,AD5->AD5_SEQUEN	,Nil})
		
		FWMVCRotAuto(FWLoadModel("FATA310"),"AD5",5,{{"AD5MASTER",aCabec}},.F.)

		AD5->(DbSkip())
	Enddo

Return Nil
