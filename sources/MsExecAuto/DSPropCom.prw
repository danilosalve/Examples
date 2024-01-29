#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
 
 /*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 14/04/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function DSPropCom()

    Local nOperation   := 3
    Local aADZProduto  := {}
    Local aADYMaster   := {}
    Local aADZAcessor  := {}
    Local lRetorno      := .T.

    Private lMsErroAuto := .F.

    //-----------------------------------------------
    // Cabeçalho da Proposta Comercial
    //----------------------------------------------
    aAdd( aADYMaster, {"ADY_OPORTU" , "000003", Nil } )
    aAdd( aADYMaster, {"ADY_REVISA" , "01", Nil } )
    aAdd( aADYMaster, {"ADY_DATA"   , dDatabase, Nil } )
    aAdd( aADYMaster, {"ADY_ENTIDA" , "1", Nil } ) //1=Cliente; 2=Prospect
    aAdd( aADYMaster, {"ADY_CODIGO" , "000001", Nil } )
    aAdd( aADYMaster, {"ADY_LOJA"   , "00", Nil } )
    aAdd( aADYMaster, {"ADY_TABELA" , "CR1", Nil } )

    //-----------------------------------------------
    // Itens da Proposta Comercial - Folder Produtos
    //-----------------------------------------------
    aAdd( aADZProduto,{ {"ADZ_PRODUT", "CRM001", Nil } ,;
    {"ADZ_CONDPG", "001", Nil } ,;
    {"ADZ_TES", "502", Nil } ,;
    {"ADZ_QTDVEN", 2, Nil } ,;
    {"ADZ_CODAGR", "000004", Nil },;
    {"ADZ_CODNIV", "001", Nil } } )

    //-------------------------------------------------
    // Itens da Proposta Comercial - Folder Acessórios
    //-------------------------------------------------
    aAdd( aADZAcessor, { {"ADZ_PRODUT", "CRM002", Nil },;
    {"ADZ_CONDPG", "001", Nil } ,;
    {"ADZ_TES", "502", Nil } ,;
    {"ADZ_QTDVEN", 4, Nil } } )

    FATA600( /*oMdlFt300*/, nOperation, aADYMaster, aADZProduto, aADZAcessor )

    If lMsErroAuto
        lRetorno := .F.
        DisarmTransaction()
        MostraErro()
    Else
        Conout( "Proposta incluída com sucesso.!" )
    EndIf
    
return Nil
