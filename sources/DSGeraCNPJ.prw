#INCLUDE "PROTHEUS.CH" 

//-------------------------------------------------------------------
/*/{Protheus.doc} DSGeraCNPJ
    Gerador de CNPJ

    @type  Function
    @author Danilo Salve
    @since 18/06/2019
    @version 1.0
    @param nBase, Numerico, Base do CNPJ - Opcional
    @return cRet, Caractere, CNPJ
    @example
    DSGeraCNPJ("12346789012")    
/*/
//-------------------------------------------------------------------
Function DSGeraCNPJ( nBase )
    Local cBase as character
    Local cRet  as character
    Local nDv   as numeric

    Default nBase   := Randomize( 0 , 999999999 )

    nBase := StrZero( IIF( ValType( nBase ) == "N", nBase, Val( nBase ) ), 12)
    cBase := CValTochar( nBase )
    nDv := CalcDv( cBase , 5 )
    cBase := cBase + CValToChar( nDv )
    nDv := CalcDv( cBase , 6 )
    cRet := cBase + CValToChar( nDv )
Return cRet

//-------------------------------------------------------------------
/*/{Protheus.doc} CalcDv
    Calcula o digito verificador
    
    @type  Static
    @author Danilo Salve
    @since 18/06/2019
    @version 1.0
    @param nBase, Caractere, Base do CNPJ
    @param nMult, Multiplicador
    @return nRet, Numerico, Digito Verificador
    @example
    CalcDv("12346789012",5)    
/*/
//-------------------------------------------------------------------

Static Function CalcDv( cBase , nMult )
    Local nI    as numeric
    Local nMod  as numeric
    Local nRet  as numeric

    Default cBase := "000000000000"
    Default nMult := 0

    For nI := 1 To Len( cBase )

        nRet += Val( Substr( cBase, nI, 1 ) ) * nMult
        nMult--

        If nMult == 1
            nMult := 9
        Endif
    
    Next nI
    
    nMod := Mod( nRet, 11 )
    nRet := IIF( nMod < 2, 0, 11 - nMod )
Return nRet
