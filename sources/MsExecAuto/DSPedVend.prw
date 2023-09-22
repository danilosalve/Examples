#INCLUDE "PROTHEUS.CH"

//------------------------------------------------------------------------------
/*/{Protheus.doc} DSPedVend
    Exemplo ExecAuto Pedido de Venda

    @sample	    DSPedVend() 
    @return		Nulo    , Nulo  	, Nulo

    @author		Danilo Salve
    @since		30/04/2019
    @version	1.0
/*/
//------------------------------------------------------------------------------
Function DSPedVend()
    Local aCabec    := {}
    Local aItem     := {}
    Local aItens    := {}
    Local lDevol    := .T.
    
    Private lMsErroAuto := .F.

    ConOut( Repl( "-", 80 ) )   

    If lDevol
        ConOut( PadC( "Teste de Inclusao de 1 pedido de venda do tipo devolução com 1 item ", 80 ) )

        // +----------------------------------+
        // | Teste Pedido de Venda - Devolção |
        // +----------------------------------+
        
        aAdd( aCabec, { "C5_TIPO"      , "D"            , Nil } )
        aAdd( aCabec, { "C5_CLIENTE"   , "000001"       , Nil } )
        aAdd( aCabec, { "C5_LOJACLI"   , "01"           , Nil } )
        aAdd( aCabec, { "C5_LOJAENT"   , "01"           , Nil } )
        aAdd( aCabec, { "C5_CONDPAG"   , "006"          , Nil } )
        
        aItem := {}
        aAdd( aItem, { "C6_ITEM"    , "01"          , Nil } )
        aAdd( aItem, { "C6_PRODUTO" , "PROD00021"   , Nil } )
        aAdd( aItem, { "C6_QTDVEN"  , 1             , Nil } )
        aAdd( aItem, { "C6_PRCVEN"  , 4099.98       , Nil } )
        aAdd( aItem, { "C6_PRUNIT"  , 4099.98       , Nil } )
        aAdd( aItem, { "C6_VALOR"   , 4099.98       , Nil } )
        aAdd( aItem, { "C6_TES"     , "501"         , Nil } )
        aAdd( aItem, { "C6_NFORI"   , "000000002"   , Nil } )
        aAdd( aItem, { "C6_SERIORI" , "001 "        , Nil } )
        aAdd( aItem, { "C6_ITEMORI" , "0001"        , Nil } )
        aAdd( aItens, aItem ) 

        aItem := {}
        aAdd( aItem, { "C6_ITEM"    , "02"          , Nil } )
        aAdd( aItem, { "C6_PRODUTO" , "PROD00021"   , Nil } )
        aAdd( aItem, { "C6_QTDVEN"  , 1             , Nil } )
        aAdd( aItem, { "C6_PRCVEN"  , 4099.98       , Nil } )
        aAdd( aItem, { "C6_PRUNIT"  , 4099.98       , Nil } )
        aAdd( aItem, { "C6_VALOR"   , 4099.98       , Nil } )
        aAdd( aItem, { "C6_TES"     , "501"         , Nil } )
        aAdd( aItem, { "C6_NFORI"   , "000000003"   , Nil } )
        aAdd( aItem, { "C6_SERIORI" , "001 "        , Nil } )
        aAdd( aItem, { "C6_ITEMORI" , "0001"        , Nil } )
        aAdd( aItens, aItem )
    Endif

    ConOut("Inicio: "+Time())

    MSExecAuto( {| x, y, z | MATA410( x, y, z ) }, aCabec, aItens, 3 )

    If !lMsErroAuto
        ConOut("Incluido com sucesso! ")
    Else
        ConOut("Erro na inclusao!")
        If !IsBlind()
            MostraErro()
        Endif
    EndIf

    ConOut("Fim  : "+Time())
Return Nil
