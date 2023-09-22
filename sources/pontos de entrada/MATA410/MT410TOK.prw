#INCLUDE "Protheus.ch"

//-----------------------------------------------------------
/*/{Protheus.doc} MT410BRW
    Este ponto de entrada é executado ao clicar no botão OK e pode ser usado para validar a confirmação das operações: incluir,  alterar, copiar 
    e excluir.Se o ponto de entrada retorna o conteúdo .T., o sistema continua a operação, caso contrário, volta para a tela do pedido.
    @type function
    @author Danilo Salve
    @since 08/05/2019
    @version 1.0
/*/
//-----------------------------------------------------------
user function MT410TOK()
    Local nOpc  := PARAMIXB[1]	// Opcao de manutencao
    local lRet  := .T.

    If nOpc <> 3 // Se Diferente de Inclusão
        If __cUserId <> 'XXXXXX' .and. RTrim(M->C5_ORIGEM) == 'TGV.SALESORDER' // Valida Apenas Pedidos de Venda com origem do Portal Gestão de vendas
            Help('', 1, OemToAnsi( "Acesso Negado" ),, OemToAnsi( "Usuário não possui para alterar ou Excluir o Pedido de Venda" ) , 1, 0)
        Endif
    EndIf
return lRet
