#INCLUDE "Protheus.ch"

//-----------------------------------------------------------
/*/{Protheus.doc} MT410BRW
    Este ponto de entrada � executado ao clicar no bot�o OK e pode ser usado para validar a confirma��o das opera��es: incluir,  alterar, copiar 
    e excluir.Se o ponto de entrada retorna o conte�do .T., o sistema continua a opera��o, caso contr�rio, volta para a tela do pedido.
    @type function
    @author Danilo Salve
    @since 08/05/2019
    @version 1.0
/*/
//-----------------------------------------------------------
user function MT410TOK()
    Local nOpc  := PARAMIXB[1]	// Opcao de manutencao
    local lRet  := .T.

    If nOpc <> 3 // Se Diferente de Inclus�o
        If __cUserId <> 'XXXXXX' .and. RTrim(M->C5_ORIGEM) == 'TGV.SALESORDER' // Valida Apenas Pedidos de Venda com origem do Portal Gest�o de vendas
            Help('', 1, OemToAnsi( "Acesso Negado" ),, OemToAnsi( "Usu�rio n�o possui para alterar ou Excluir o Pedido de Venda" ) , 1, 0)
        Endif
    EndIf
return lRet
