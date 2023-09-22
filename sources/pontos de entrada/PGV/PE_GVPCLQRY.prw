#INCLUDE "PROTHEUS.CH"

//-----------------------------------------------------------
/*/{Protheus.doc} GVPCLQRY
     O ponto de entrada GVPCLQRY ser� executado no momento 
     da consulta de Tabelas de Pre�os, permitindo 
     complementar o filtro da query a ser processada 
     para o Portal Gest�o de Vendas (PGV).
    @type function
    @author Squad CRM/Faturamento
    @since 28/07/2023
    @version 1.0
/*/
//-----------------------------------------------------------
User Function GVPCLQRY()
    Local cQuery := ""
    cQuery := " AND DA0.DA0_CODTAB <> '002' " 
Return cQuery
