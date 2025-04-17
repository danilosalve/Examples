#INCLUDE "PROTHEUS.CH"

#Define STR00001  OemToAnsi( "DSLockName" )
#Define STR00002  OemToAnsi( "Essa rotina não poderá ser utilizada enquanto houver o mesmo processo de estiver em execução." )
#Define STR00003  OemToAnsi( "Feche todas as rotinas para obter exclusividade de acesso nesta rotina." )

//-----------------------------------------------------------------
/*/{Protheus.doc} DSLockName
    Exemplo de Utilização da função LockByName - Semaforo

    @type  Function
    @author Danilo Salve
    @since 01/06/2019
    @version 1.0
    @param param, param_type, param_descr
    @return Nulo
    @example DSLockName()
    @see http://tdn.totvs.com/x/rvxn
/*/
//-----------------------------------------------------------------
Function DSLockName()
    Local cNomeFunc      := "DSLockName"
    Local lLockByEmp    := .F.
    Local lLockByFil    := .F.

    If !LockByName( cNomeFunc, lLockByEmp, lLockByFil)        
        Help( Nil, Nil, STR00001, NIL, STR00002, 1, 0, NIL, NIL, NIL, NIL, NIL, { STR00003 })
    Endif

    /*
    * Desativa Semaforo
    * UnLockByName("NOME_DA_SUA_ROTINA",.F.,.F.)
    */
Return Nil
