#Include 'Protheus.ch'

#Define STRTITULO  OemToAnsi("Fontes Compilados")
#Define STRPROC001 OemToAnsi("Processando dados...")
#Define STREXCEL01 OemToAnsi("Carregando dados no excel...")
#Define STREXCEL02 OemToAnsi("Gerando dados no excel...")

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪目北
北砅rograma  砇CMS006.prw    ?Autor ?Danilo Otavio Lima Salve        ?Data ?23/04/2018 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪拇北
北矰escricao ?Gera Relatorio Excel com todos os fontes do RPO									潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北砋so       ?SIGAESP1                                                                    潮?
北媚哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北?Atualizacoes sofridas desde a Construcao Inicial.                                      潮?
北媚哪哪哪哪哪哪穆哪哪哪哪哪履哪哪哪哪哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北?Programador  ?Data     ?Projeto/Ocor   ? Motivo da Alteracao                        潮?
北媚哪哪哪哪哪哪呐哪哪哪哪哪拍哪哪哪哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌*/

Function ESPR001()
	//Declaracao de Array - Local
	Local aBotoes	:= {}
	Local aSays	:= {}

	/*########################
	## Monta tela principal ##
	########################*/
	
	aAdd( aSays,OemToAnsi(" Este programa ira gerar um relatorio com os fontes	"))
	aAdd( aSays,OemToAnsi(" compilados no RPO.								"))
	aAdd( aBotoes, { 1, .T., { || Processa({|| ProcFunc() },STRPROC001) } } )
	aAdd( aBotoes, { 2, .T., { || FechaBatch() } } )
	
	FormBatch( STRTITULO, aSays, aBotoes, , 200,350 )

Return Nil

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪目北
北?Funcao   ?ProcFunc      ?Autor 矰anilo Otavio Lima Salve         ?Data ?23/04/2018 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪拇北
北矰escricao ?Funcao responsavel por processar dados do RPO.									潮?
北?         ?             																		潮?
北媚哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘*/

Static Function ProcFunc()
	//Declaracao de variavel numerica - Local
  Local nCount
  // Para retornar nome do fonte
  Private aFontes
  // Para retornar a origem da fun玢o: FULL, USER, PARTNER, PATCH, TEMPLATE ou NONE
  Private aType
  // Para retornar o nome do arquivo onde foi declarada a fun玢o
  Private aFile
  // Para retornar o n鷐ero da linha no arquivo onde foi declarada a fun玢o
  Private aLine
  // Para retornar a data da 鷏tima modifica玢o do c骴igo fonte compilado
  Private aDate
  // Para retornar a hora da 鷏tima modifica玢o do c骴igo fonte compilado
  Private aTime   
  // Buscar informa珲es de todas as fun珲es contidas no APO
  // tal que tenham a substring 'test' em algum lugar de seu nome
  aFontes := GetFuncArray('*', aType, aFile, aLine, aDate,aTime)
  nCount	:= Len(aFontes)
  
  GeraExcel()

Return Nil

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北谀哪哪哪哪穆哪哪哪哪哪哪哪穆哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪穆哪哪哪履哪哪哪哪哪目北
北?Funcao   ?GeraExcel     ?Autor 矰anilo Otavio Lima Salve         ?Data ?23/04/2018 潮?
北媚哪哪哪哪呐哪哪哪哪哪哪哪牧哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪牧哪哪哪聊哪哪哪哪哪拇北
北矰escricao ?Funcao responsavel por gerar relatorio em excel.								潮?
北?         ?             																		潮?
北媚哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪拇北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘*/


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
	//Defini玢o dos padr鮡s do relatorio - Cores de Preenchimento da Celula e Fonte
	oFWMsEx:SetTitleFrColor("#000000") 	//Descri玢o: Define a cor da fonte do estilo do Titulo
	oFWMsEx:SetTitleBgColor("#FFFFFF") 	//Descri玢o: Define a cor de preenchimento do estilo do Titulo
	oFWMsEx:SetFrColorHeader("#FFFFFF") 	//Descri玢o: Define a cor da fonte do estilo do Cabe鏰lho
	oFWMsEx:SetBgColorHeader("#003366")	//Descri玢o: Define a cor de preenchimento do estilo do Cabe鏰lho
	oFWMsEx:SetLineFrColor("#000000") 	//Descri玢o: Define a cor da fonte do estilo da Linha
	oFWMsEx:SetLineBgColor("#FFFFFF") 	//Descri玢o: Define a cor de preenchimento do estilo da Linha
	oFWMsEx:Set2LineFrColor("#000000")	//Descri玢o: Define a cor dda fonte do estilo da Linha 2
	oFWMsEx:Set2LineBgColor("#FFFFFF")	//Descri玢o: Define a cor de preenchimento  do estilo da Linha 2
	
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

