#INCLUDE "PROTHEUS.CH"

//-----------------------------------------------------------
/*/{Protheus.doc} GVFLDC5
    Este ponto de entrada é chamado pela API de integração
    de campos personalizados, para informar quais campos
	adicionais da tabela SC5, personalizados ou não, sejam
	considerados pelo PGV além dos padrões
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
