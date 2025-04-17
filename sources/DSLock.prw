#Include "TOTVS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} DSLock
    Teste de Lock utilizando softlock
    @type  Function
    @author Danilo Salve
    @since 18/03/2020
    @version 1.0    
    @example
    DSLock()
    @see
        https://tdn.totvs.com/x/yYFzAQ
/*/
//-------------------------------------------------------------------
Function DSLock()
    Local cAlias    := "SA1"
    Local aLockList := {}

    DbSelectArea(cAlias)
    DbSetOrder(1)

    Conout(Replicate('-',50))
    Conout('Iniciando Teste...')
    Conout('Thread: ' + cValToChar(ThreadId()))
    Conout(Replicate('-',50))

    
    If SoftLock(cAlias)
        Conout('Efetuei o Lock do registro: ' + cValToChar(Recno()))
        aLockList := SA1->(DBRLockList())
        nPosLock := AScan( aLockList, Recno() )

        If nPosLock > 0
            Conout("Registro esta Travado")
        Endif

        Conout('Thread: ' + cValToChar(ThreadId()))
        //Sleep( 15000 )
    else
        Conout('Nao foi possivel travar o registro')
        Conout('Thread: ' + cValToChar(ThreadId()))
    Endif

    Conout(Replicate('-',50))
    Conout('Finalizando Teste...')
    Conout('Thread: ' + cValToChar(ThreadId()))
    Conout(Replicate('-',50))

    aSize(aLockList, 0)    
Return Nil
