#INCLUDE "TOTVS.CH"

//-----------------------------------------------------------------------------------
/*/{Protheus.doc} DSLogRPO
    @description
    Imprime no Console do AppServer a lista de patchs aplicados

    @type  Function
    @author Danilo Salve
    @since  21/02/2020
    @version 1.0
    @return Nulo
    @example DSLogRPO()
/*/
//-----------------------------------------------------------------------------------
Function DSLogRPO()

    Local aData     := GetRpoLog()
    Local nPatch    := 0
    Local nProgram  := 0
    Local nTotal    := 0
    Local nTpPatch  := 0

    ConOut( Replicate("-",40))        
    ConOut("Qtd de Patchs Aplicados:        " + CValToChar(aData[2]))    

    For nPatch := 3 To Len(aData)

        ConOut( Replicate("-",40))
        ConOut("Nome Patch:                     " + CValToChar(aData[ nPatch,1]))
        ConOut("Data de geracao do patch:       " + DTOC(aData[nPatch,2]))
        ConOut("Build de geracao do patch:      " + aData[nPatch,3])
        ConOut("Data de aplicacao do patch:     " + DTOC(aData[nPatch,4]))
        ConOut("Build de aplicacao do patch:    " + aData[nPatch,5])
        nTotal :=  IIF(aData[nPatch,6] > 0,aData[nPatch,6] + 6,0)
        nTpPatch := IIF(nTotal > 0, aData[nPatch,nTotal + 2],0)

        If nTpPatch == 1
            ConOut("Tipo do patch: 1 - UPD")
        Elseif nTpPatch == 2
            ConOut("Tipo do patch: 2 - PAK")
        Elseif nTpPatch == 3
            ConOut("Tipo do patch: 3 - PTM")
        Endif

        ConOut( Replicate("_",40))
        ConOut("| Nome do programa |  Data do Programa")
        ConOut( Replicate("_",40))
        For nProgram := 7 To nTotal
            ConOut("| " + aData[nPatch,nProgram, 1] + " - " + DTOC(aData[nPatch,nProgram, 2]))
        Next nProgram
        ConOut( Replicate("_",40))
        ConOut( Replicate("-",40))

    Next nPatch

    aSize(aData, 0)

Return Nil