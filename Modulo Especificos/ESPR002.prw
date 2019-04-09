#Include 'Protheus.ch'

/*/{Protheus.doc} ESPR002
Relatorio de campos Protheus

@author  Danilo Salve
@version P12
@since   27/08/2018
/*/

Function ESPR002()

	//Declaracao de array local
	Local aMvPar	:= {}
	Local aPar		:= {}
	Local aRet		:= {}
	//Declaracao de variaveis numericas
	Local nMv		:= 0
	//Declaracao de variaveis caractere
	Private cCadastro	:= OemToAnsi("Campos - SX3")
	Private aUser	:= {}
	
	/*##############################################
	## Guarda os paramentros originais da rotina. ##
	##############################################*/
	
	For nMv := 1 To 60
		aAdd( aMvPar, &( "MV_PAR" + StrZero( nMv, 2, 0 ) ) )
	Next nMv
	
	aAdd( aPar, { 1, "Alias " 				,Space(3),"","","","",0,.T.})
	AAdd( aPar, { 5, "Somente Obrigatorios"	,.F.,150,"",.F.})
	
	If ParamBox( aPar , cCadastro, @aRet, ,,,,,,'RCPSOBG' , .T., .T. )
		FWMsgRun(,{|| ProcAlias(MV_PAR01)}, cCadastro,OemToAnsi("Processando aguarde..."))
	Endif
	
	/*################################################
	## Restaura os paramentros originais da rotina. ##
	################################################*/
	
	For nMv := 1 To Len( aMvPar )
		&( "MV_PAR" + StrZero( nMv, 2, 0 ) ) := aMvPar[ nMv ]
	Next nMv

	aSize(aMvPar,0)
	aSize(aPar,0)
	aSize(aRet,0)

Return Nil

/*/{Protheus.doc} ProcAlias

Carrega array com os dados da tabela

@author  Danilo Salve
@version P12
@since   08/02/2019
/*/

Static Function ProcAlias(cAlias)

    Local aAreaSX3  := SX3->(GetArea())
    Local aDados    := {}
    Local lReturn   := .T.
	Local lObrigat	:= .F.
    
    SX3->(DbSetOrder(1))
    If SX3->(DbSeek(cAlias)) 
        While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAlias
			lObrigat := X3Obrigat(SX3->X3_CAMPO)
			If MV_PAR02
				iF lObrigat 
					aAdd(aDados, {SX3->X3_CAMPO, SX3->X3_TITULO, SX3->X3_DESCRIC, SX3->X3_TIPO, SX3->X3_TAMANHO,;
						SX3->X3_DECIMAL, "Sim"})
				Endif
			Else
				aAdd(aDados, {SX3->X3_CAMPO, SX3->X3_TITULO, SX3->X3_DESCRIC, SX3->X3_TIPO, SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL, IIF(lObrigat,"Sim","Não")})
			Endif
            SX3->(DbSkip())
        Enddo
    Else
		HELP(' ',1,OemToAnsi("Alias"),,OemToAnsi("Alias não localizado"),2,0,,,,,,OemToAnsi("Verifique os parametros iniciais"))
        lReturn := .F.
    Endif

    If lReturn .And. Len(aDados) > 0
        GeraRel(aDados)
	Else
		HELP(' ',1,OemToAnsi("NODADOS"),,OemToAnsi("Não há dados"),2,0,,,,,,OemToAnsi("Verifique os parametros iniciais"))
    Endif

    RestArea(aAreaSX3)
    aSize(aAreaSX3,0)
    aSize(aDados,0)

Return lReturn

/*/{Protheus.doc} GeraRel

Gera planilha com os campos do Alias informado

@author  Danilo Salve
@version P12
@since   08/02/2019
/*/

Static Function GeraRel(aDados)
	//Declaracao de variavel de variavel caractere - Local
	Local cArq 			:= ""
	Local cTable 		:= ""
	Local cWorkSheet	:= ""
	Local cDirTmp 		:= GetTempPath()
	//Declaracao de objeto - Local
	Local oFwMsEx 		:= NIL
	//Declaracao de variavel Numerica - Locdal
	Local nI				:= 0
	
	cWorkSheet := "Campos"
	cTable     := "Relatorio de campos (SX3) - Protbeus"
	oFwMsEx	 := FWMsExcel():New()
	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:AddTable ( cWorkSheet, cTable )
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Campo", 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Titulo ", 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Descrição", 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Tipo", 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Tamanho", 1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Decimal", 1,1)	
	oFwMsEx:AddColumn( cWorkSheet, cTable , "Obrigatoriedade", 1,1)

	//Definicao dos padroes do relatorio - Cores de Preenchimento da Celula e Fonte
	oFWMsEx:SetTitleFrColor( "#000000" ) //Descri?o: Define a cor da fonte do estilo do Titulo
	oFWMsEx:SetTitleBgColor( "#FFFFFF" ) //Descri?o: Define a cor de preenchimento do estilo do Titulo
	oFWMsEx:SetFrColorHeader( "#FFFFFF" ) //Descri?o: Define a cor da fonte do estilo do Cabe?lho
	oFWMsEx:SetBgColorHeader( "#003366" ) //Descri?o: Define a cor de preenchimento do estilo do Cabe?lho
	oFWMsEx:SetLineFrColor( "#000000" ) //Descri?o: Define a cor da fonte do estilo da Linha
	oFWMsEx:SetLineBgColor( "#FFFFFF" ) //Descri?o: Define a cor de preenchimento do estilo da Linha
	oFWMsEx:Set2LineFrColor( "#000000" ) //Descri?o: Define a cor dda fonte do estilo da Linha 2
	oFWMsEx:Set2LineBgColor( "#FFFFFF" ) //Descri?o: Define a cor de preenchimento  do estilo da Linha 2

	For nI	:= 1 to Len(aDados)
		oFwMsEx:AddRow( cWorkSheet, cTable, {aDados[nI,1],;
		aDados[nI,2],;
		aDados[nI,3],;
		aDados[nI,4],;
		aDados[nI,5],;
		aDados[nI,6],;
		aDados[nI,7]})
	Next nI
		
	oFwMsEx:Activate()
	cArq := CriaTrab( NIL, .F. ) + ".xml"
	LjMsgRun( OemToAnsi("Gerando o arquivo, aguarde..."), OemToAnsi("Relatorio de Campos"), {|| oFwMsEx:GetXMLFile( cArq ) } )
	If __CopyFile( cArq, cDirTmp + cArq )
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDirTmp + cArq )
		oExcelApp:SetVisible(.T.)
		MsgInfo( OemToAnsi("Arquivo ") + cArq + OemToAnsi(" gerado com sucesso no diretorio ") + cDirTmp )		
	Else
		MsgInfo( OemToAnsi("Arquivo não copiado para area temporia.") )
	Endif

    FreeObj(oExcelApp)
	FreeObj(oFwMsEx)
	aSize(aDados,0)
	
Return Nil