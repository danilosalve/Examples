#INCLUDE "PROTHEUS.CH"

//-----------------------------------------------------------
/*/{Protheus.doc} GVFLDC5
    Este ponto de entrada � chamado pela API de integra��o
    de campos personalizados, para informar quais campos
	adicionais da tabela SC5, personalizados ou n�o, sejam
	considerados pelo PGV al�m dos padr�es
    @type function
    @author Squad CRM/Faturamento
    @since 20/04/2023
    @version 1.0
/*/
//-----------------------------------------------------------
user function GVFLDC5()
	local aSC5:= {}
	aAdd(aSC5, "C5_RECFAUT")
return aSC5
