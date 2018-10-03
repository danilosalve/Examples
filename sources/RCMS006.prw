#Include 'Protheus.ch'

#Define STRTITULO  OemToAnsi("Fontes Compilados")
#Define STRPROC001 OemToAnsi("Processando dados...")
#Define STREXCEL01 OemToAnsi("Carregando dados no excel...")
#Define STREXCEL02 OemToAnsi("Gerando dados no excel...")

/*��������������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������Ŀ��
���Programa  �RCMS006.prw    � Autor � Danilo Otavio Lima Salve        � Data � 23/04/2018 ���
������������������������������������������������������������������������������������������Ĵ��
���Descricao � Gera Relatorio Excel com todas User Function										���
������������������������������������������������������������������������������������������Ĵ��
���Uso       � SIGAESP1                                                                    ���
������������������������������������������������������������������������������������������Ĵ��
��� Atualizacoes sofridas desde a Construcao Inicial.                                      ���
������������������������������������������������������������������������������������������Ĵ��
��� Programador  � Data     � Projeto/Ocor   �  Motivo da Alteracao                        ���
������������������������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������*/

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

/*��������������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������Ŀ��
��� Funcao   � ProcFunc      � Autor �Danilo Otavio Lima Salve         � Data � 23/04/2018 ���
������������������������������������������������������������������������������������������Ĵ��
���Descricao � Funcao responsavel por processar dados do RPO.									���
���          �              																		���
������������������������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������*/

Static Function ProcFunc()
	//Declaracao de variavel numerica - Local
  Local nCount
  // Para retornar nome do fonte
  Private aFontes
  // Para retornar a origem da fun��o: FULL, USER, PARTNER, PATCH, TEMPLATE ou NONE
  Private aType
  // Para retornar o nome do arquivo onde foi declarada a fun��o
  Private aFile
  // Para retornar o n�mero da linha no arquivo onde foi declarada a fun��o
  Private aLine
  // Para retornar a data da �ltima modifica��o do c�digo fonte compilado
  Private aDate
  // Para retornar a hora da �ltima modifica��o do c�digo fonte compilado
  Private aTime   
  // Buscar informa��es de todas as fun��es contidas no APO
  // tal que tenham a substring 'test' em algum lugar de seu nome
  aFontes := GetFuncArray('*', aType, aFile, aLine, aDate,aTime)
  nCount	:= Len(aFontes)
  
  GeraExcel()

Return Nil

/*��������������������������������������������������������������������������������������������
����������������������������������������������������������������������������������������������
������������������������������������������������������������������������������������������Ŀ��
��� Funcao   � GeraExcel     � Autor �Danilo Otavio Lima Salve         � Data � 23/04/2018 ���
������������������������������������������������������������������������������������������Ĵ��
���Descricao � Funcao responsavel por gerar relatorio em excel.								���
���          �              																		���
������������������������������������������������������������������������������������������Ĵ��
����������������������������������������������������������������������������������������������
��������������������������������������������������������������������������������������������*/


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
	//Defini��o dos padr�es do relatorio - Cores de Preenchimento da Celula e Fonte
	oFWMsEx:SetTitleFrColor("#000000") 	//Descri��o: Define a cor da fonte do estilo do Titulo
	oFWMsEx:SetTitleBgColor("#FFFFFF") 	//Descri��o: Define a cor de preenchimento do estilo do Titulo
	oFWMsEx:SetFrColorHeader("#FFFFFF") 	//Descri��o: Define a cor da fonte do estilo do Cabe�alho
	oFWMsEx:SetBgColorHeader("#003366")	//Descri��o: Define a cor de preenchimento do estilo do Cabe�alho
	oFWMsEx:SetLineFrColor("#000000") 	//Descri��o: Define a cor da fonte do estilo da Linha
	oFWMsEx:SetLineBgColor("#FFFFFF") 	//Descri��o: Define a cor de preenchimento do estilo da Linha
	oFWMsEx:Set2LineFrColor("#000000")	//Descri��o: Define a cor dda fonte do estilo da Linha 2
	oFWMsEx:Set2LineBgColor("#FFFFFF")	//Descri��o: Define a cor de preenchimento  do estilo da Linha 2
	
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

