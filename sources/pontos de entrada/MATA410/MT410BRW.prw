#INCLUDE "Protheus.ch"

//-----------------------------------------------------------
/*/{Protheus.doc} MT410BRW
    Este ponto de entrada é chamado antes da apresentação da mbrowse.
    @type function
    @author Danilo Salve
    @since 08/05/2019
    @version 1.0
/*/
//-----------------------------------------------------------
User Function MT410BRW()
    Local aArea := GetArea()
    Local aAreaSC5 := SC5->(GetArea())
    Local aCabec := {}
    Local aItens := {}

    SC5->(DbSetOrder(3))
    If SC5->(DbSeek(xFilial("SC5") + "FTR21301"))
        While SC5->( !Eof() ) .And. SC5->( C5_CLIENTE + C5_LOJACLI ) == "FTR21301"
            aCabec := {}
            aItens := {}
            aadd( aCabec, { "C5_NUM", SC5->C5_NUM, Nil } )
            MSExecAuto( { | x, y, z| MATA410( x, y, z ) }, aCabec, aItens, 5 )
            ConOut( Repl( "-", 80 ) )
            Conout("PV excluido: " + SC5->C5_NUM )
            ConOut( Repl( "-", 80 ) )
            SC5->( DbSkip() )
        Enddo
    Endif

    RestArea(aAreaSC5)
    RestArea(aArea)

    aSize( aItens, 0)
    aSize( aCabec, 0)
    aSize( aAreaSC5, 0)
    aSize( aArea, 0)
Return Nil
