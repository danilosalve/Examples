#Include "Protheus.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} DSLerTxt
    Exemplo de utilização de metodos de Leitura de Arquivos binarios

    @param		Nenhum
    @return     Nulo
    @author 	Danilo Salve
    @version	12.1.23
    @since		05/04/2019
/*/
//-------------------------------------------------------------------
Function DSLerTxt()
    Local cArquivo      := "compilar.txt"
    Local cDiretorio    := "C:\TOTVS\workspace\VsCode\ADVPR\"
    
    Conout( "Teste FWFileReader: " )
    Conout( "Inicio: " + Time() )
    LeArquivo1( cDiretorio + cArquivo )
    Conout( "Fim: " + Time() )

    Conout( "---------------------" )
    
    Conout( "Teste FT_FReadLn: " )
    Conout( "Inicio: " + Time() )
    LeArquivo2( cDiretorio + cArquivo )
    Conout( "Fim: " + Time() )
Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} LeArquivo1
    Efetua a Leitura de Arquivos utilizando a classe FWFileReader

    @param		Nenhum
    @return     Nulo
    @author 	Danilo Salve
    @version	12.1.23
    @since		20/05/2019
/*/
//-------------------------------------------------------------------

Static function LeArquivo1( cFile )
    Local oFile := Nil

    oFile := FWFileReader():New( cFile )

    //Abre o Arquivo
    If ( oFile:Open() )
        //Retorna o tamanho do arquivo em Bytes
        Conout( "Tamanho do Arquivo: " + CValToChar( oFile:getFileSize() ) + " bytes" )
        //Laço enquanto encontrar linhas no arquivo
        While ( oFile:hasLine() )
            //Retorna Linha
            Conout( oFile:GetLine() )
        Enddo
        //Fecha Arquivo
        oFile:Close()

    Else
        Conout( "Não foi possivel abrir o arquivo " )
    Endif
Return


//-------------------------------------------------------------------
/*/{Protheus.doc} LeArquivo2
    Efetua a Leitura de Arquivos utilizando a classe FT_FUse

    @param		Nenhum
    @return     Nulo
    @author 	Danilo Salve
    @version	12.1.23
    @since		20/05/2019
/*/
//-------------------------------------------------------------------

Static function LeArquivo2( cFile )
    Local cLine     := ""
    Local nHandle   := 0
    Local nRecno    := 0    

    // Abre o arquivo
    nHandle := FT_FUse( cFile )
    // Se houver erro de abertura abandona processamento
    if nHandle <> -1
        // Posiciona na primeria linha
        FT_FGoTop()
        // Retorna o número de linhas do arquivo
        Conout("Quantidade de Linhas: " + CValToChar( FT_FLastRec() ) )
        //Enquanto não foi final de arquivo
        While !FT_FEOF()
            // Retorna a linha corrente
            cLine  := FT_FReadLn()
            // Retorna o recno da Linha
            nRecno := FT_FRecno()
        
            Conout( "Linha: " + cLine + " - Recno: " + StrZero( nRecno, 3 ) )
            // Pula para próxima linha
            FT_FSKIP()
        Enddo
        // Fecha o Arquivo
        FT_FUSE()

    Else        
        Conout( "Não foi possivel abrir o arquivo "  + CValToChar( FError() ) )
    Endif
Return Nil
