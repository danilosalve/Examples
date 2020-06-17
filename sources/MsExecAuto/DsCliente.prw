#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"

#DEFINE STRDSCLI01 OemToAnsi("O Codigo do Cliente ou Loja não foram informados")
#DEFINE STRDSCLI02 OemToAnsi("Por favor informe o codigo e a loja do cliente")
#DEFINE STRDSCLI03 OemToAnsi("Falha ao adicionar conteudo")
#DEFINE STRDSCLI04 OemToAnsi("Por favor informe o campo é o valor")

//------------------------------------------------------------------
/*/{Protheus.doc} DsCliente
    Inclui um Cliente automaticamente.

    @sample     DsCliente( "12345678000190" )
    @author 	Danilo Salve
    @since 		09/08/2019
    @version 	1.0
    @param		cCnpj   , Caractere , CNPJ 
    @return     lRet    , Logico    , Retorna se o processo foi executado com sucesso.
/*/
//-------------------------------------------------------------------
Function DsCliente( cCnpj )

    Local aErro     := {}
    Local aDados    := {}
    Local cCodigo   := ""
    Local cLoja     := "01"
    Local lRet      := .F.
    Local oCliente    

    Default cCnpj := "00000000000000"

    If ConsCNPJ( cCnpj , @oCliente )
        cCodigo := GetCodCli( cCnpj, @cLoja )
        aDados := MapCli(cCodigo, cLoja, oCliente)

        If !Empty(aDados)
            lRet := DSCmtCli(aDados, 3)
        Endif

    Else
        lRet := .F.
    Endif    

    FreeObj(oCliente)    
    aSize(aErro, 0)
    aSize(aDados, 0)

Return lRet

//------------------------------------------------------------------
/*/{Protheus.doc} ConsCNPJ
    Consulta o CNPJ na receita e alimenta o Objeto cliente.

    @sample     ConsCNPJ("00.000.000/0001-01", oCliente)
    @author 	Danilo Salve
    @since 		09/08/2019
    @version 	1.0
    @param		cCnpj   , Caractere , CNPJ 
    @return     lRet    , Logico    , Retorna se o processo foi executado com sucesso.
    @see        https://receitaws.com.br/api
/*/
//-------------------------------------------------------------------
Static Function ConsCNPJ( cCnpj , oCliente )
    
    Local cURL      := "https://www.receitaws.com.br/v1/cnpj/"
    Local lRet      := .T.      
    Local oRest     := Nil

    Default cCnpj       := "00000000000000"
    Default oCliente    := Nil

    cCnpj := StrZero( Val( StrTran( StrTran( StrTran(cCnpj, ".", ""), "-", ""), "/", "") ), 14 )

    oRest := FWRest():New( cUrl )
    oRest:setPath( cCnpj )

    If oRest:Get()        
        oCliente := JsonObject():New()
        lRet := FWJsonDeserialize(DecodeUtf8( oRest:GetResult() ),@oCliente)
    Else
        ConOut( DecodeUtf8( oRest:GetLastError() ) )
        lRet := .F.
    Endif

    FreeObj( oRest )

Return lRet

//------------------------------------------------------------------
/*/{Protheus.doc} GetCodCli
    Retorna o codigo do cliente.

    @sample     GetCodCli("00.000.000/0001-01", @cLoja)
    @author 	Danilo Salve
    @since 		09/08/2019
    @version 	2.0
    @param		cCnpj   , Caractere     , CNPJ 
    @param		cLoja   , Caractere     , Loja passado por referencia
    @return     cCodigo , Caractere     , Codigo do Cliente
/*/
//-------------------------------------------------------------------
Static Function GetCodCli( cCnpj, cLoja )

    Local cBase     := ""
    Local cCodigo   := ""
    Local lContinua := .T.

    Default cLoja := "01"

    If Empty( cCnpj )
        Help(' ',1,"CNPJ" ,,"CNPJ não informado",2,0,,,,,, "Informe o CNPJ e tente novamente" )
        lContinua := .F.
    Else
        cBase   := Substring(cCnpj,1,8)
    Endif

    If lContinua
        cCodigo := BuscaLoja(cBase, @cLoja)

        If Empty( cCodigo )
            cCodigo := NextCodCli()      
        Endif
    Endif

Return cCodigo

//------------------------------------------------------------------
/*/{Protheus.doc} BuscaLoja
    Verifica se já existe cliente cadastrado utilizando mesma base do CNPJ e retorna o codigo do cliente e loja(Por referencia).

    @sample     GetCodCli("00000000", @cLoja)
    @author 	Danilo Salve
    @since 		05/04/2020
    @version 	1.0
    @param		cBase   , Caractere     , Base do CNPJ
    @param		cLoja   , Caractere     , Loja passado por referencia
    @return     cCodigo , Caractere     , Codigo do Cliente
/*/
//------------------------------------------------------------------
Static Function BuscaLoja(cBase, cLoja)

    Local aArea     := GetArea()
    Local cAliasSA1 := GetNextAlias()
    Local cCodigo   := ""
        
    Default cLoja   := "01" 

    BeginSql Alias cAliasSA1
        SELECT 
            A1_COD, 
            MAX(A1_LOJA) LOJA
        FROM 
            %table:SA1% SA1
        WHERE 
            A1_FILIAL = %xfilial:SA1%
            AND SUBSTRING(A1_CGC,1,8) = %exp:cBase%
            AND SA1.%notDel%
        GROUP BY 
            A1_COD
        ORDER BY A1_COD ASC
    EndSQL

    While (cAliasSA1)->(!Eof())
        cCodigo := (cAliasSA1)->A1_COD
        cLoja   := Soma1((cAliasSA1)->LOJA)
        (cAliasSA1)->(DbSkip())
    Enddo

    (cAliasSA1)->(DbCloseArea())

    RestArea(aArea)
    aSize(aArea, 0)

Return cCodigo

//------------------------------------------------------------------
/*/{Protheus.doc} NextCodCli
    Retorna o proximo codigo de cliente

    @sample     NextCodCli()
    @author 	Danilo Salve
    @since 		05/03/2020
    @version 	1.0
    @return     cCodigo , Caractere     , Codigo do Cliente
/*/
//------------------------------------------------------------------
Static Function NextCodCli()

    Local aArea     := GetArea()
    Local cCodigo   := "000001"
    Local cAliasSA1 := GetNextAlias()

    BeginSql Alias cAliasSA1
        SELECT 
            ISNULL(MAX(A1_COD),'000001') CODIGO                
        FROM 
            %table:SA1% SA1
        WHERE 
            A1_FILIAL = %xfilial:SA1%                
            AND SA1.%notDel%
    EndSQL

    While (cAliasSA1)->(!Eof())
        cCodigo := Soma1((cAliasSA1)->CODIGO)
        (cAliasSA1)->(DbSkip())
    Enddo

    (cAliasSA1)->(DbCloseArea())

    RestArea(aArea)
    aSize(aArea, 0)

Return cCodigo

//------------------------------------------------------------------
/*/{Protheus.doc} MapCli
    Efetua o de-para dos campos retornados pela API com o Cadastro de cliente    

    @sample     MapCli( "000001", "01", oCliente )
    @author 	Danilo Salve
    @since 		05/04/2020
    @version 	1.0
    @param		cCodigo , Caractere , Codigo do Cliente.
    @param		cLoja   , Caractere , Loja do Cliente.
    @param      oCliente, Objeto    , Dados do cliente retornado pela API.
    @return     lRet    , Logico    , Retorna se o processo foi executado com sucesso.
/*/
//-------------------------------------------------------------------
Static Function MapCli(cCodigo, cLoja, oCliente)

    Local aRet      := {}
    Local cEndereco := ""
    Local cCnae     := ""
    Local lContinua := .T.

    Default cCodigo     := ""
    Default cLoja       := ""
    Default oCliente    := Nil

    If Empty(cCodigo) .Or. Empty(cLoja)
        Help('', 1, STRDSCLI01,, STRDSCLI02, 1, 0)
        lContinua := .F.
    Endif

    If lContinua

        aAdd(aRet, {"A1_COD"        , cCodigo   , Nil})
        aAdd(aRet, {"A1_LOJA"       , cLoja     , Nil})
        aAdd(aRet, {"A1_RISCO"      , "A"       , Nil})
        aAdd(aRet, {"A1_MOEDALC"    , 1         , Nil})
        aAdd(aRet, {"A1_ULTVIS"    , Date()     , Nil})
        aAdd(aRet, {"A1_TMPVIS"    , "01:00"    , Nil})
        aAdd(aRet, {"A1_TMPSTD"    , "01:00"    , Nil})
        
        If AttIsMemberOf(oCliente, "NOME")
            aAdd(aRet, {"A1_NOME", oCliente:NOME, Nil})
        Endif

        If AttIsMemberOf(oCliente, "FANTASIA")
            aAdd(aRet, {"A1_NREDUZ", oCliente:FANTASIA, Nil})
        Endif

        If AttIsMemberOf(oCliente, "CNPJ")
            aAdd(aRet, {"A1_PESSOA" , "J", Nil})
            aAdd(aRet, {"A1_TIPO"   , "F", Nil})
            aAdd(aRet, {"A1_CGC", StrTran(StrTran(StrTran(oCliente:CNPJ,".",""),"-",""),"/",""), Nil})            
        Endif

        If AttIsMemberOf(oCliente, "ABERTURA")
            aAdd(aRet, {"A1_DTNASC", CTOD(oCliente:ABERTURA), Nil})
        Endif

        If AttIsMemberOf(oCliente, "ATIVIDADE_PRINCIPAL") .And. !Empty(oCliente:ATIVIDADE_PRINCIPAL)
            cCnae := StrTran(StrTran(oCliente:ATIVIDADE_PRINCIPAL[1]:CODE,".",""),"-","")
            aAdd(aRet, {"A1_CNAE", TRANSFORM(cCnae, "@R 9999-9/99"), Nil})
        Endif

        If AttIsMemberOf(oCliente, "LOGRADOURO")
            cEndereco := oCliente:LOGRADOURO
            If AttIsMemberOf(oCliente, "NUMERO")
                cEndereco += ", " + oCliente:NUMERO
            Else
                cEndereco += ", S/N"
            Endif

            aAdd(aRet, {"A1_END", cEndereco, Nil })

            If AttIsMemberOf(oCliente, "COMPLEMENTO")
                aAdd(aRet, {"A1_COMPLEM", oCliente:COMPLEMENTO, Nil})
            Endif
        Endif

        If AttIsMemberOf(oCliente, "BAIRRO")
            aAdd(aRet, {"A1_BAIRRO", oCliente:BAIRRO, Nil})
        Endif

        If AttIsMemberOf(oCliente, "CEP")
            aAdd(aRet, {"A1_CEP", StrTran(StrTran(oCliente:CEP,".",""),"-",""), Nil})
        Endif

        If AttIsMemberOf(oCliente, "UF")
            aAdd(aRet, {"A1_PAIS", "105", Nil})
            aAdd(aRet, {"A1_CODPAIS", "01058", Nil})
            aAdd(aRet, {"A1_EST", oCliente:UF, Nil})
        Endif

        If AttIsMemberOf(oCliente, "MUNICIPIO")
            aAdd(aRet, {"A1_MUN", oCliente:MUNICIPIO, Nil})
        Endif

        If AttIsMemberOf(oCliente, "EMAIL")
            aAdd(aRet, {"A1_EMAIL", oCliente:EMAIL, Nil})
        Endif

        If AttIsMemberOf(oCliente, "TELEFONE")    
            aAdd(aRet, {"A1_DDI", "55", Nil})
            aAdd(aRet, {"A1_DDD", SubStr(oCliente:TELEFONE,2,2), Nil})
            aAdd(aRet, {"A1_TEL", StrTran(SubStr(oCliente:TELEFONE,6),"-",""), Nil})
        Endif       

    Endif

Return aRet

//------------------------------------------------------------------
/*/{Protheus.doc} DSCmtCli
    Efetua a gravação do cliente.

    @sample     DSCmtCli( aDados, 3 )
    @author 	Danilo Salve
    @since 		04/03/2020
    @version 	1.0
    @param		aDados  , Array     , Array com estrutra de campos, valor e validação (Padrão MSExecAuto)
    @param		cLoja   , Numerico  , Operação (3 - Incluir, 4 - Alterar, 5 - Excluir...)
    @return     lRet    , Logico    , Retorna se o processo foi executado com sucesso.
/*/
//-------------------------------------------------------------------
Static Function DSCmtCli(aDados, nOpc)

    Local aMsgErro  := {}
    Local lRet      := .T.
    Local nI        := 0
    Local oModel
    Local oModelSA1

    Default aDados := {}
    Default nOpc    := 0

    oModel := FWLoadModel("CRMA980")
    oModelSA1:= oModel:GetModel("SA1MASTER")

    Do Case
    Case nOpc == 3
        oModel:SetOperation(MODEL_OPERATION_INSERT)
    Case nOpc == 4
        oModel:SetOperation(MODEL_OPERATION_UPDATE)
    Case nOpc == 5
        oModel:SetOperation(MODEL_OPERATION_DELETE)
    Otherwise
        lRet := .F.
    EndCase

    oModel:Activate()

     If oModel:IsActive()

        If oModel:GetOperation() <> MODEL_OPERATION_DELETE
            For nI := 1 To Len(aDados)
                If !oModelSA1:SetValue(aDados[nI,1], aDados[nI,2])
					lRet := .F.                   
					Exit
				EndIf
            Next nI
        Endif
    Else
        lRet := .F.
    Endif

    If !lRet .Or. !( oModel:VldData() .And. oModel:CommitData() )
		aMsgErro := oModel:GetErrorMessage()        
        For nI := 1 To Len(aMsgErro)
            If ValType(aMsgErro[nI]) == "C"
                Conout(StrTran( StrTran( aMsgErro[nI], "<", "" ), "-", "" ) + (" "))
            EndIf
        Next nI
        lRet := .F.
    Else
        Conout("Cliente Cadastrado com sucesso!")
	Endif

    oModel:DeActivate()
    
    FreeObj(oModelSA1)
    FreeObj(oModel)
    aSize(aMsgErro, 0)

Return lRet