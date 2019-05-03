#INCLUDE "PROTHEUS.CH"

#Define STRPROCESS  OemToAnsi( "Gerando Documento de Entrada..." )

//------------------------------------------------------------------------------
/*/{Protheus.doc} DSDocEnt
    Exemplo ExecAuto Documento de Entrada - Compras

    @sample	    DSDocEnt() 
    @return		Nulo    , Nulo  	, Nulo

    @author		Danilo Salve
    @since		25/04/2019
    @version	1.0
/*/
//------------------------------------------------------------------------------
Function DSDocEnt()

    Processa( { || MyMata103() }, "Aguarde..." , STRPROCESS, .T. )

Return Nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} MyMata103    

    @sample	    MyMata103() 
    @return		Nulo    , Nulo  	, Nulo

    @author		Danilo Salve
    @since		25/04/2019
    @version	1.0
/*/
//------------------------------------------------------------------------------
Static Function MyMata103()

    Local cNumDoc   := "000000503"
    Local nI        := 0
    Local nTotal    := 400

    ProcRegua(nTotal)

    For nI := 1 To nTotal
        cNumDoc := Soma1( cNumDoc )
        If lEnd
            MsgStop( OemToAnsi( "Cancelado pelo usuario" ), OemToAnsi("Atenção" ) ) 
            Exit
        Endif
        GravaDoc( cNumDoc )            
        IncProc( STRPROCESS + cValtoChar( nI ) + " de " + cValtoChar( nTotal ) )
    Next nI

Return Nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} GravaDoc
    Retorna as colunas utilizadas no browse

    @sample	    GravaDoc( cNumDoc )
    @param		cNumDoc	, Caractere	, Numero do Documento  
    @return		Nulo    , Nulo  	, Nulo

    @author		Danilo Salve
    @since		25/04/2019
    @version	1.0
/*/
//------------------------------------------------------------------------------
Static Function GravaDoc( cNumDoc )

    Local aCabec    := {}
    Local aItem     := {}
    Local aItens    := {}    
    Local nX        := 0
    
    Private lMsErroAuto := .F.
    Private lMsHelpAuto := .T.
    
    Default cNumDoc := "000000001"

    ConOut( " +-------+ Inicio +-------+" )    

    aAdd( aCabec, {"F1_TIPO"    , "N"       , NIL } )
    aAdd( aCabec, {"F1_FORMUL" 	, "N"       , NIL } )
    aAdd( aCabec, {"F1_DOC"    	, cNumDoc   , NIL } )
    aAdd( aCabec, {"F1_SERIE"  	, "001"     , NIL } )
    aAdd( aCabec, {"F1_EMISSAO"	, dDataBase , NIL } )
    aadd( aCabec, {"F1_DTDIGIT" , dDataBase , NIL } )	
    aAdd( aCabec, {"F1_FORNECE"	, "000001"  , NIL } )
    aAdd( aCabec, {"F1_LOJA"   	, "01"      , NIL } )
    aAdd( aCabec, {"F1_ESPECIE"	, "NF"      , NIL } )
    aAdd( aCabec, {"F1_EST"		, "RS"      , NIL } )
    aAdd( aCabec, {"F1_COND"	, "006"     , NIL } )
    aAdd( aCabec, {"F1_DESPESA" , 0         , NIL } )
    aAdd( aCabec, {"F1_DESCONT" , 0         , Nil } )
    aAdd( aCabec, {"F1_COND"    , "001"     , NIL } )
    aAdd( aCabec, {"F1_SEGURO"  , 0         , Nil } )
    aAdd( aCabec, {"F1_FRETE"   , 0         , Nil } )
    aAdd( aCabec, {"F1_MOEDA"   , 1         , Nil } )
    aAdd( aCabec, {"F1_TXMOEDA" , 1         , Nil } )
    aAdd( aCabec, {"F1_STATUS"  , "A"       , Nil } )
    aAdd( aCabec, {"F1_VALMERC" , 16299,96  , NIL } )
    aAdd( aCabec, {"F1_VALBRUT" , 18744,95  , NIL } )
    aAdd( aCabec, {"F1_PESOL"   , 0         , NIL } )
    aAdd( aCabec, {"F1_IPI"     , 0         , NIL } )
    
    aAdd( aItem, { "D1_ITEM"  		, "0001"        , Nil } )
    aAdd( aItem, { "D1_COD"  		, "PROD00005"   , Nil } )
    aAdd( aItem, { "D1_UM"  		, "UN"          , Nil } )
    aAdd( aItem, { "D1_QUANT"		, 2             , Nil } )
    aAdd( aItem, { "D1_VUNIT"		, 6099.99       , Nil } )
    aAdd( aItem, { "D1_TOTAL"		, 12199.98      , Nil } )
    aAdd( aItem, { "D1_TES"		    , "001"         , Nil } )
    aAdd( aItem, { "D1_CF"		    , "2403"        , Nil } )
    aAdd( aItem, { "D1_IPI"		    , 15            , Nil } )        
    aAdd( aItem, { "D1_LOCAL"		, "01"          , Nil } )
    aAdd( aItem, { "D1_CLASFIS"		, "210"         , Nil } )
    aAdd( aItem, { "D1_RATEIO"		, "2"           , Nil } )
    aAdd( aItem, { "D1_ALIQSOL"		, 17            , Nil } )

    aAdd( aItens, aItem )
    aItem := {}

    aAdd( aItem, { "D1_ITEM"  		, "0002"        , Nil } )
    aAdd( aItem, { "D1_COD"  		, "PROD00021"   , Nil } )
    aAdd( aItem, { "D1_UM"  		, "UN"          , Nil } )
    aAdd( aItem, { "D1_QUANT"		, 1             , Nil } )
    aAdd( aItem, { "D1_VUNIT"		, 4099.98       , Nil } )
    aAdd( aItem, { "D1_TOTAL"		, 4099.98       , Nil } )
    aAdd( aItem, { "D1_TES"		    , "001"         , Nil } )
    aAdd( aItem, { "D1_CF"		    , "2403"        , Nil } )
    aAdd( aItem, { "D1_IPI"		    , 15            , Nil } )        
    aAdd( aItem, { "D1_LOCAL"		, "01"          , Nil } )
    aAdd( aItem, { "D1_CLASFIS"		, "210"         , Nil } )
    aAdd( aItem, { "D1_RATEIO"		, "2"           , Nil } )
    aAdd( aItem, { "D1_ALIQSOL"		, 17            , Nil } )

    aAdd( aItens, aItem )		

    MSExecAuto( { | x, y, z | Mata103( x, y, z ) }, aCabec, aItens, 3 )        

    ConOut( " +------------------------------------------+" )
    If lMsErroAuto
        ConOut( " Problema ao incluir documento de entrada " )
        If !IsBlind()
            MostraErro()
        Endif
    Else            
        ConOut( " Inclusão realizada com sucesso! " + cNumDoc )
    EndIf
    ConOut( " +------------------------------------------+ " )
    ConOut( " +-------+ Fim +-------+" )

    aSize( aCabec, 0 )
    aSize( aItens, 0 )
    aSize( aItem, 0 )

Return Nil