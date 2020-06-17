#INCLUDE "TOTVS.CH"

//------------------------------------------------------------------
/*/{Protheus.doc} DSTpEntSai()
Inclusao de Tipo de entrada e saida utilizando MSExecAuto

@author 	Danilo Salve
@since 		10/03/2020
@version 	1.0
@sample     DSTpEntSai()
/*/
//-------------------------------------------------------------------
User Function DSTpEntSai()

    Local aArea := GetArea()
    Local aCab  := {}
    Local cErro := ""
    Local nOpc  := 0
    Local cOpc  := ""

    Private lMsErroAuto := .F.

    /*
        nOpc
        1 - Pesquisa ( Não utilzado no ExecAuto )
        2 - Visualiza ( Não utilzado no ExecAuto )
        3 - Inclui
        4 - Altera
        5 - Exclui
    */

    DbSelectArea("SF4")
    SF4->(DbSetOrder(1))

    If SF4->(DbSeek(xFilial("SF4") + "010"))
        nOpc := 4
        cOpc  := "Alterado"
    Else
        nOpc := 3
        cOpc  := "Incluido"
    Endif

    aAdd(aCab, {"F4_CODIGO"  ,"010"                     , Nil})
    aAdd(aCab, {"F4_TIPO"    ,"E"                       , Nil})
    aAdd(aCab, {"F4_CREDICM" ,"N"                       , Nil})
    aAdd(aCab, {"F4_CREDIPI" ,"N"                       , Nil})
    aAdd(aCab, {"F4_DUPLIC"  ,"S"                       , Nil})
    aAdd(aCab, {"F4_ESTOQUE" ,"S"                       , Nil})
    aAdd(aCab, {"F4_ICM"     ,"N"                       , Nil})
    aAdd(aCab, {"F4_PODER3"  ,"N"                       , Nil})
    aAdd(aCab, {"F4_IPI"     ,"N"                       , Nil})
    aAdd(aCab, {"F4_CF"      ,"1101"                    , Nil})

    If nOpc == 3
        aAdd(aCab, {"F4_TEXTO"   ,"ENTRADA - S/ IMPOSTOS"   , Nil})
    Elseif nOpc == 4
        aAdd(aCab, {"F4_TEXTO"   ,"ALTERADO"                , Nil})
    Endif

    aAdd(aCab, {"F4_LFICM"   ,"N"                       , Nil})
    aAdd(aCab, {"F4_LFIPI"   ,"N"                       , Nil})
    aAdd(aCab, {"F4_DESTACA" ,"N"                       , Nil})
    aAdd(aCab, {"F4_INCIDE"  ,"N"                       , Nil})
    aAdd(aCab, {"F4_COMPL"   ,"N"                       , Nil})    

    MSExecAuto({|x,y| Mata080(x,y)},aCab,nOpc)

    If lMsErroAuto
        ConOut("Erro na inclusao!")
        cErro:= MostraErro()
    Else
        ConOut( cOpc + " com sucesso! ")
    Endif

    SF4->(DbCloseArea())

    RestArea(aArea)

    aSize(aArea, 0)
    aSize(aCab, 0)

Return Nil