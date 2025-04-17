#INCLUDE "PROTHEUS.CH"
#INCLUDE "Fileio.ch"

//------------------------------------------------------------------
/*/{Protheus.doc} DSGravaTxt
    Exemplo de Gravação de Arquivo de Texto .Txt

    @author 	Danilo Salve
    @since 		17/05/2019
    @version    1.0
    @example    DSGravaTxt()
    @see        http://tdn.totvs.com/pages/viewpage.action?pageId=23889341
    @see        http://tdn.totvs.com/display/tec/FCreate
/*/
//-------------------------------------------------------------------
Function DSGravaTxt()
    Local aFile         := {}
    Local aDados        := {}
    Local aDiretorio    := {}
    Local cDiretorio    := "C:\TOTVS\workspace\VsCode\ADVPR\"
    Local nI            := 0

    //Verifica se diretorio existe
    If ExistDir( cDiretorio )
        //Retorna todos arquivos e Pasta de um diretorio
        aDiretorio := Directory( cDiretorio + "*.*", "D" )
        For nI := 1 To Len( aDiretorio )
            If aDiretorio[ nI, 5 ] == "D"
                //Cases
                If ExistDir( cDiretorio + "\" + aDiretorio[ nI, 1 ] + "\" + "Cases" )
                    aFile := Directory( cDiretorio + "\" + aDiretorio[ nI, 1 ] + "\" + "Cases" + "\*.prw")
                    RetFile( aFile , @aDados )
                EndIf
                //Group
                If ExistDir( cDiretorio + "\" + aDiretorio[ nI,1 ] + "\" + "Group" )
                    aFile := Directory( cDiretorio + "\" + aDiretorio[ nI, 1 ] + "\" + "Group" + "\*.prw")
                    RetFile( aFile , @aDados )
                EndIf
                //Suite
                If ExistDir( cDiretorio + "\" + aDiretorio[ nI, 1 ] + "\" + "Suite" )
                    aFile := Directory( cDiretorio + "\" + aDiretorio[ nI, 1 ] + "\" + "Suite" + "\*.prw")
                    RetFile( aFile , @aDados )
                EndIf
            Endif
        Next nI

        If Len( aDados ) > 0
            GravaArq( cDiretorio, aDados )
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
    @Param      cDiretorio  , Caracter  , Diretorio onde o arquivo sera gerado
    @Param      aDados      , Array     , Dados a serem gravado
    @example    RetFile( aFile , aDados )
    @see        http://tdn.totvs.com/display/tec/FCreate
/*/
//-------------------------------------------------------------------
Static Function GravaArq( cDiretorio, aDados )
    Local nHandle   := FCreate( cDiretorio + "\Compilar.txt" )
    Local nX        := 0
 
    if nHandle = -1
        Conout( "Erro ao criar arquivo" + Str( Ferror() ) )
    else
        For nX := 1 To Len( aDados )
            FWrite( nHandle, aDados[ nX ] + CRLF )
        Next nX        
        FClose( nHandle )
    endif
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
