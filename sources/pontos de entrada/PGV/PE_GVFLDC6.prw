#INCLUDE "PROTHEUS.CH"

//-----------------------------------------------------------
/*/{Protheus.doc} GVFLDC6
    Este ponto de entrada é chamado pela API de integração
    de campos personalizados, para informar quais campos
	adicionais da tabela SC6, personalizados ou não, sejam
	considerados pelo PGV além dos padrões
    @type function
    @author Squad CRM/Faturamento
    @since 20/04/2023
    @version 1.0
/*/
//-----------------------------------------------------------
user function GVFLDC6() as array
	local aSC6:= {} as array
	aAdd(aSC6, "C6_CC")
	aAdd(aSC6, "C6_PEDCOM")
    aAdd(aSC6, "C6_PRODFIN")
    aAdd(aSC6, "C6_FCICOD")
    aAdd(aSC6, "C6_OBSCONT")
    aAdd(aSC6, "")
    aAdd(aSC6, "C6_ABOBRINHA")
    aAdd(aSC6, "C6_NUM")
return aSC6
