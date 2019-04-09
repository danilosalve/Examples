#Include "Protheus.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} DSbubble
    Exemplo de algoritimo de metodo de ordenação Bolha

    @param		Nenhum
    @return     Nulo
    @author 	Danilo Salve
    @version	12.1.23
    @since		05/04/2019
/*/
//-------------------------------------------------------------------
Function DSbubble()

    Local aVetor:= {8, 9, 3, 5, 1, 20, 2, 34, 99,12}    

    ImpVetor(aVetor, "Vetor desordenado: ")

    bubbleSort(@aVetor)

    ImpVetor(aVetor, "Vetor Ordenado: ")

    aSize(aVetor,0)
    aVetor := {}

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} bubbleSort
    Realiza a ordenação usando algoritmo - BubbleSort

    @param		aVetor, Array, Array com dados para ordenação
    @return     Nulo
    @author 	Danilo Salve
    @version	12.1.23
    @since		09/04/2019
    @example    bubbleSort(aArray)
/*/
//-------------------------------------------------------------------

Static Function ImpVetor(aVetor, cTitulo)

    Local nI    := 0

    Conout(" ")
    Conout("===============================")
    Conout(cTitulo)
    Conout("===============================")
    Conout(" ")

    For nI := 1 To Len(aVetor)
        Conout(CValToChar(aVetor[nI]))
    Next nI

    Conout(" ")
    Conout("===============================")
    Conout(" ")


Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} bubbleSort
    Realiza a ordenação usando algoritmo - BubbleSort

    @param		aVetor, Array, Array com dados para ordenação
    @return     Nulo
    @author 	Danilo Salve
    @version	12.1.23
    @since		09/04/2019
    @example    bubbleSort(aArray)
/*/
//-------------------------------------------------------------------

Static Function bubbleSort(aVetor)

    Local nI    := 0
    Local nJ    := 0
    Local nAux  := 0

    For nI := 1 To Len(aVetor)
        For nJ := 1 To Len(aVetor) - 1
            If aVetor[nJ] > aVetor[nJ + 1]
                nAux            := aVetor[nJ]
                aVetor[nJ]      := aVetor[nJ + 1]
                aVetor[nJ + 1]  := nAux
            Endif
        Next nJ
    Next nI
    
Return Nil




