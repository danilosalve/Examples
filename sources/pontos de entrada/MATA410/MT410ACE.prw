#include 'rwmake.ch'

User Function Mt410Ace()
	Local lContinua := .T.
	Local nOpc  := PARAMIXB[1]

	If ISINCALLSTACK('SAVESALESORDERS') // Somente Pedidos de Vendas com Origem no Portal Gest�o de Vendas
		IF nOpc == 1 // excluir
			IF cUsuario <> 'XXXXXX'
			Help('', 1, OemToAnsi( "Acesso Negado" ),, OemToAnsi( "Usu�rio n�o possui acesso para Excluir o Pedido de Venda" ) , 1, 0)
				lContinua := .F.
			EndIf
		ElseIf nOpc == 4 // Alterar
			IF cUsuario <> 'XXXXXX'
				Help('', 1, OemToAnsi( "Acesso Negado" ),, OemToAnsi( "Usu�rio n�o possui acesso para alterar o Pedido de Venda" ) , 1, 0)
				lContinua := .F.
			EndIf
		Endif
	Endif
Return lContinua
