#INCLUDE "Protheus.ch"

#Define STR00001 OemToAnsi( "Gerar Arquivo TXT" )
#Define STR00002 OemToAnsi( "Parâmetros" )

//-------------------------------------------------------------------
/*/{Protheus.doc} ESPA002
    Este programa tem a finalidade Ler todos os Arquivos de um diretorio
    e Listar/Imprimir os mesmo em um arquivo de Texto

    @param		Nenhum
    @return     Nulo
    @author 	Squad CRM & Faturamento
    @version	1.0
    @since		07/05/2019
/*/
//-------------------------------------------------------------------
Function ESPA002()
    
	Local aBotoes	 := {}
	Local aSays	     := {}
    Local cDirFile   := ""
    Local lOk        := .F.

	Private cCadastro	:= STR00001
	
	aAdd( aSays, OemToAnsi(" Este programa tem como objetivo gerar um arquivo de Texto "))
	aAdd( aSays, OemToAnsi(" Com todos os arquivos listados em um diretorio. "))
	aAdd( aBotoes, { 1, .T., { || Iif( lOk ,( fProcDir( cDirFile ) , FechaBatch() ),) } } )
	aAdd( aBotoes, { 2, .T., { || FechaBatch() } } )
	aAdd( aBotoes, { 5, .T., { || LoadPar( @lOk, @cDirFile )} } )

    FormBatch( cCadastro, aSays, aBotoes, , 200, 450 )

    aSize( aBotoes, 0 )    
    aSize( aSays, 0 )	

Return Nil

//-----------------------------------------------------------
/*/{Protheus.doc} Menudef
    Menu funcional da rotina

    @sample Menudef()
	@Return	aRotina	, Array	, Array de Rotinas
    @author Danilo Salve
    @since 07/05/2019
    @version 1.0
    @return Nulo    
/*/
//-----------------------------------------------------------
Static Function Menudef()

    Local aRotina := {}
    
    aRotina	:= { { STR00001	, "ESPA002"	, 0, 8, 0, Nil } }

Return aRotina

//-----------------------------------------------------------
/*/{Protheus.doc} LoadPar
    Esta função tem carregar os parametros iniciais do relatorio.
   
    @sample LoadPar( @lOk )
	@param	lOk		    , Logico	    , lOk
    @return cRetFile    , Caractere		, Retornar os arquivos selecionados
    @author Danilo Salve
    @since 07/05/2019
    @version 1.0	
/*/
//-----------------------------------------------------------
Static Function LoadPar( lOk, cDirFile )
    
    Local cMascara  := "Todos *|*.*"
    Local cTitulo   := "Escolha o arquivo"
    Local nMascpad  := 0
    Local cDirini   := "C:\"

    cDirFile := cGetFile( cMascara, cTitulo, nMascpad, cDirIni, .F. )

    If Empty( cDirFile )
        lOk := .F.
    Else
        cDirFile := Substr( cDirFile , 1, Rat( "\", cDirFile  ))
        lOk := .T.
    Endif
	
Return cDirFile

//-----------------------------------------------------------
/*/{Protheus.doc} fProcDir
    Função responsavel por efetuar a leitura dos diretorios informados
   
    @sample fProcDir( )    
    @author Danilo Salve
    @since 07/05/2019
    @version 1.0	
/*/
//-----------------------------------------------------------
Static Function fProcDir( cDirFile )

    Local aFile         := {}
    Local aDados        := {}
    Local aDiretorio    := {}    
    Local nI            := 0
	Local nTotal	    := 0    

    If ExistDir( cDirFile )
    
        aDiretorio := Directory( cDirFile + "*.*", "D" )

        nTotal := Len( aDiretorio )

        If nTotal == 0
		    Help( " ", 1, "ARQVAZIO" )
		    Return Nil
	    Endif

        For nI := 1 To Len( aDiretorio )
            If aDiretorio[ nI, 5 ] == "D"
    
                If ExistDir( cDirFile + "\" + aDiretorio[ nI, 1 ] + "\" + "Cases" )
                    aFile := Directory( cDirFile + "\" + aDiretorio[ nI, 1 ] + "\" + "Cases" + "\*.prw")
                    RetFile( aFile , @aDados )
                EndIf
    
                If ExistDir( cDirFile + "\" + aDiretorio[ nI,1 ] + "\" + "Group" )
                    aFile := Directory( cDirFile + "\" + aDiretorio[ nI, 1 ] + "\" + "Group" + "\*.prw")
                    RetFile( aFile , @aDados )
                EndIf
    
                If ExistDir( cDirFile + "\" + aDiretorio[ nI, 1 ] + "\" + "Suite" )
                    aFile := Directory( cDirFile + "\" + aDiretorio[ nI, 1 ] + "\" + "Suite" + "\*.prw")
                    RetFile( aFile , @aDados )
                EndIf
            Endif
        Next nI

        If Len( aDados ) > 0
            GravaArq( cDirFile, aDados )
        Else
            Help( " ", 1, "ARQVAZIO" )
        Endif
    Else
        Help( '', 1, OemToAnsi( "Diretorio" ) , , OemToAnsi( "Diretorio não localizado" ), 1, 0 )
    Endif

    aSize( aFile, 0 )
    aSize( aDados, 0 )
    aSize( aDiretorio, 0 )
	
Return Nil

//------------------------------------------------------------------
/*/{Protheus.doc} GravaArq
    Grava um arquivo de Texto - TXT utilizando a função FCreate

    @author 	Danilo Salve    
    @since 		17/05/2019
    @version    1.0    
    @Param      cDirFile  , Caracter  , Diretorio onde o arquivo sera gerado
    @Param      aDados      , Array     , Dados a serem gravado
    @example    RetFile( aFile , aDados )
    @see        http://tdn.totvs.com/display/tec/FCreate
/*/
//-------------------------------------------------------------------
Static Function GravaArq( cDirFile, aDados )

    Local nHandle   := FCreate( cDirFile + "\Compilar.txt" )
    Local nX        := 0
 
    If nHandle = -1
        Help( '', 1, OemToAnsi( "ARQUIVO" ) , , OemToAnsi( "Erro ao criar arquivo" ) + Str( Ferror() ), 1, 0 )        
    Else

        For nX := 1 To Len( aDados )
            FWrite( nHandle, aDados[ nX ] + CRLF )
        Next nX

        FClose( nHandle )

        MsgInfo( OemToAnsi( "Arquivo gerado com sucesso!" ) )
    Endif

Return Nil

//------------------------------------------------------------------
/*/{Protheus.doc} RetFile
    Retorna o array com os dados a serem gravados

    @author 	Danilo Salve
    @since 		17/05/2019
    @version    1.0    
    @Param      aFile  , Array      , Arquivos
    @Param      aDados , Array      , Dados a serem gravado
    @example    RetFile( aFile , aDados )
/*/
//-------------------------------------------------------------------
Static Function RetFile( aFile , aDados )

    Local nY    := 0

    For nY := 1 To Len( aFile )
        aAdd( aDados, aFile[ nY, 1 ] )
    Next nY

Return Nil