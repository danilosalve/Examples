#INCLUDE "PROTHEUS.CH"

//------------------------------------------------------------------------------
/*/{Protheus.doc} DSCtRecSE1
    Exemplo ExecAuto Contas a Receber - Financeiro

    @sample	    DSCtRecSE1() 
    @return		lRet    , Logico  	, Retorna se o processo foi executado

    @author		Danilo Salve
    @since		30/05/2019
    @version	1.0
/*/
//------------------------------------------------------------------------------

Function DSCtRecSE1( nOpc )

    Local aTitulos      := {}    
    Local cTipo         := "NF "
    Local lRet          := .T.
    Local nI            := 0
    Local nValor

    Private lMsErroAuto := .F.

    Default nOpc    := 3

    While ++nI .And. nI < 50

        nValor := Randomize( 0 , 999999 )
        
        AAdd( aTitulos , { "E1_PREFIXO"  , "MAN"         , NIL } )
        AAdd( aTitulos , { "E1_NUM"      , StrZero( nI , 9 )    , NIL } )
        AAdd( aTitulos , { "E1_TIPO"     , cTipo         , NIL } )
        AAdd( aTitulos , { "E1_NATUREZ"  , "00001"       , NIL } )
        AAdd( aTitulos , { "E1_CLIENTE"  , "000001"      , NIL } )
        AAdd( aTitulos , { "E1_LOJA"     , "01"          , NIL } )
        AAdd( aTitulos , { "E1_EMISSAO"  , dDatabase     , NIL } )
        AAdd( aTitulos , { "E1_VENCTO"   , dDatabase + 1 , NIL } )
        AAdd( aTitulos , { "E1_VENCREA"  , dDatabase + 1 , NIL } )

        If Alltrim(cTipo) == "RA"
            AAdd( aTitulos , { "CBCOAUTO"    , "341"         , NIL } )
            AAdd( aTitulos , { "CAGEAUTO"    , "0001"        , NIL } )
            AAdd( aTitulos , { "CCTAAUTO"    , "00001"       , NIL } )
        Endif

        AAdd( aTitulos , { "E1_VALOR"    , nValor           , NIL } )                

        MsExecAuto( { |x, y| FINA040( x, y ) } , aTitulos, nOpc ) 

        If lMsErroAuto
            lRet := .F.
            If !IsBlind()
                MostraErro()
            Else
                ConOut( " Problema ao incluir Titulo a Receber " )
            Endif
        Else
            Conout(" Título incluído com sucesso! ")
            lRet := .T.
        Endif

        aSize( aTitulos, 0 )
    
    Enddo     

Return lRet