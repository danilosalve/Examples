#Include 'Protheus.ch'

#Define STRTITULO  OemToAnsi("Fontes Compilados")
#Define STRPROC001 OemToAnsi("Processando dados...")
#Define STREXCEL01 OemToAnsi("Carregando dados no excel...")
#Define STREXCEL02 OemToAnsi("Gerando dados no excel...")

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³RCMS006.prw    ³ Autor ³ Danilo Otavio Lima Salve        ³ Data ³ 23/04/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera Relatorio Excel com todas User Function										³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAESP1                                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Atualizacoes sofridas desde a Construcao Inicial.                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Programador  ³ Data     ³ Projeto/Ocor   ³  Motivo da Alteracao                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Function RCMS006()
	//Declaracao de Array - Local
	Local aBotoes	:= {}
	Local aSays	:= {}

	/*########################
	## Monta tela principal ##
	########################*/
	
	aAdd( aSays,OemToAnsi(" Este programa ira gerar um relatorio com os fontes	"))
	aAdd( aSays,OemToAnsi(" compilados no projeto (IDE).								"))
	aAdd( aBotoes, { 1, .T., { || Processa({|| ProcFunc() },STRPROC001) } } )
	aAdd( aBotoes, { 2, .T., { || FechaBatch() } } )
	
	FormBatch( STRTITULO, aSays, aBotoes, , 200,350 )

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ ProcFunc      ³ Autor ³Danilo Otavio Lima Salve         ³ Data ³ 23/04/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao responsavel por processar dados do RPO.									³±±
±±³          ³              																		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/

Static Function ProcFunc()
	//Declaracao de variavel numerica - Local
  Local nCount
  // Para retornar nome do fonte
  Private aFontes
  // Para retornar a origem da função: FULL, USER, PARTNER, PATCH, TEMPLATE ou NONE
  Private aType
  // Para retornar o nome do arquivo onde foi declarada a função
  Private aFile
  // Para retornar o número da linha no arquivo onde foi declarada a função
  Private aLine
  // Para retornar a data da última modificação do código fonte compilado
  Private aDate
  // Para retornar a hora da última modificação do código fonte compilado
  Private aTime   
  // Buscar informações de todas as funções contidas no APO
  // tal que tenham a substring 'test' em algum lugar de seu nome
  aFontes := GetFuncArray('*', aType, aFile, aLine, aDate,aTime)
  nCount	:= Len(aFontes)
  
  GeraExcel()

Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao   ³ GeraExcel     ³ Autor ³Danilo Otavio Lima Salve         ³ Data ³ 23/04/2018 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao responsavel por gerar relatorio em excel.								³±±
±±³          ³              																		³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/


Static Function GeraExcel()
	//Declaracao de variavel caractere - Local
	Local cArquivo	:= ""
	Local cDirTmp		:= GetTempPath()
	Local cWorkSheet	:= "FONTES"	
	Local cTable		:= "FONTES"
	//Declaracao de variavel numerica - Local
	Local nX			:= 0
	//Declaracao de objetos
	Local oFwMsEx		:= FWMsExcel():New()
	Local oExcelApp	
		
	oFwMsEx:AddWorkSheet( cWorkSheet )
	oFwMsEx:AddTable ( cWorkSheet, cTable )
	oFwMsEx:AddColumn( cWorkSheet, cTable ,"Funcao",1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable ,"Arquivo",1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable ,"Linha",1,1)	
	oFwMsEx:AddColumn( cWorkSheet, cTable ,"Tipo",1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable ,"Data",1,1)
	oFwMsEx:AddColumn( cWorkSheet, cTable ,"Hora",1,1)	
	//Definição dos padrões do relatorio - Cores de Preenchimento da Celula e Fonte
	oFWMsEx:SetTitleFrColor("#000000") 	//Descrição: Define a cor da fonte do estilo do Titulo
	oFWMsEx:SetTitleBgColor("#FFFFFF") 	//Descrição: Define a cor de preenchimento do estilo do Titulo
	oFWMsEx:SetFrColorHeader("#FFFFFF") 	//Descrição: Define a cor da fonte do estilo do Cabeçalho
	oFWMsEx:SetBgColorHeader("#003366")	//Descrição: Define a cor de preenchimento do estilo do Cabeçalho
	oFWMsEx:SetLineFrColor("#000000") 	//Descrição: Define a cor da fonte do estilo da Linha
	oFWMsEx:SetLineBgColor("#FFFFFF") 	//Descrição: Define a cor de preenchimento do estilo da Linha
	oFWMsEx:Set2LineFrColor("#000000")	//Descrição: Define a cor dda fonte do estilo da Linha 2
	oFWMsEx:Set2LineBgColor("#FFFFFF")	//Descrição: Define a cor de preenchimento  do estilo da Linha 2
	
	For nX := 1 to Len(aFontes)
		IncProc(STREXCEL02)
		oFwMsEx:AddRow( cWorkSheet, cTable,{;
			aFontes[nX],;
			aType[nX],;
			aFile[nX],;
			CValToChar(aLine[nX]),;
			DTOC(aDate[nX]),;
			aTime[nX]})
	Next nX
	
	oFwMsEx:Activate()	
	cArquivo := CriaTrab( NIL, .F. ) + ".xml"
	LjMsgRun( STREXCEL01, STRTITULO, {|| oFwMsEx:GetXMLFile( cArquivo ) } )
	
	If __CopyFile( cArquivo, cDirTmp + cArquivo )
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open( cDirTmp + cArquivo )
		oExcelApp:SetVisible(.T.)
		MsgInfo( "Arquivo gerado com sucesso." )
	Else
		MsgInfo( "Erro ao gerar Arquivo." )
	Endif
	
Return Nil

