#INCLUDE "PROTHEUS.CH"

#Define STR0001 OemtoAnsi("Meu FWFormBrowse")

//-----------------------------------------------------------
/*/{Protheus.doc} DSFrMrkTmp
    Exemplo de utilização do objeto FwFormBrowse utilizando Array

    @author Danilo Salve
    @since 12/04/2019
    @version 1.0
    @return Nulo
    @example DSFrMrkTmp()    
/*/
//-----------------------------------------------------------
Function DSFrMrkTmp()

    Local aFields   := {}
    Local aColumns  := GetColumns("SF1",.F.,@aFields)
    Local aIndex	:= {"F1_DOC","F1_FORNECE"}
    Local aSize		:= FWGetDialogSize( oMainWnd )
    Local bButton   := {||MsgInfo("Meu FWFormBrowse","Teste") }
    Local cAlias    := GetNextAlias()
    Local cMarca	:= GetMark()
    Local cQuery    := GetQuery("SF1", aFields, .T.)
    Local cIndex    := ""
    Local oMBrowse  := Nil

	DEFINE MSDIALOG oDlg TITLE STR0001 FROM aSize[1],aSize[2] TO aSize[3],aSize[4] PIXEL    

        oMBrowse := FWFormBrowse():New()
        oMBrowse:SetOwner(oDlg)
        oMBrowse:SetDataQuery(.T.)
        oMBrowse:SetAlias(cAlias)
        oMBrowse:SetQuery(cQuery)
        oMBrowse:AddMarkColumn({|| IIF((cAlias)->MARK == cMarca,'LBOK','LBNO')},{||SetMarK(cAlias, cMarca)},{|| .T.})
        oMBrowse:SetColumns(aColumns)
        oMBrowse:SetTemporary(.T.)        
		oMBrowse:SetMenuDef("")
        oMBrowse:SetDescription(STR0001) //Meu FWFormBrowse
        oMBrowse:DisableDetails()
        oMBrowse:DisableReports()
        oMBrowse:SetProfileID("BRW_DS")
        oMBrowse:AddButton(OemtoAnsi("Botão"),bButton,0,4,0,,,,,{OemtoAnsi("Botão")})
        oMBrowse:SetQueryIndex(aIndex)
        oMBrowse:Activate()

    ACTIVATE DIALOG oDlg CENTERED

    aSize(aFields,0)
    aSize(aColumns,0)
    aSize(aSize,0)
    FreeObj(oMBrowse)
    FreeObj(oDlg)

Return Nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} GetColumns
    Retorna as colunas utilizadas no browse

    @sample	GetColumns(cAlias,.F.)
    @param		Alias   , Caracter, Alias temporario
    @param		lMark   , Logico,   Adicionar coluna de Marcação		
    @return		aColumns, Array,    Colunas do Browse
    @return		aFields , Array,    Campos do Browse

    @author		Danilo Salve
    @since		12/04/2018
    @version	1.0
/*/
//------------------------------------------------------------------------------
Static Function GetColumns(cAlias, lMark, aFields)

    Local aAreaSX3  := SX3->(GetArea())
    Local aColumns  := {}    
    Local nLinha    := 0

    Default lMark   := .F.
    Default aFields := {}

    If lMark
        aAdd(aColumns,FWBrwColumn():New())
        aColumns[1]:SetData(&("{ || MARK }"))
        aColumns[1]:SetTitle("  ")
        aColumns[1]:SetType("C")
        aColumns[1]:SetSize(2)
        aColumns[1]:SetDecimal(0)
    Endif

    SX3->(DbSetOrder(1))
    SX3->(DbSeek(cAlias))
    While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == cAlias
        If X3Uso(SX3->X3_USADO) .And. SX3->X3_BROWSE == "S" .And. SX3->X3_CONTEXT <> "V" .And. SX3->X3_TIPO <> "M"            
            aAdd(aColumns,FWBrwColumn():New())
            aAdd(aFields,SX3->X3_CAMPO)
            nLinha := Len(aColumns)

            If Empty(X3CBox())
				aColumns[nLinha]:SetData(&("{ || " + SX3->X3_CAMPO + " }"))
			Else
				aColumns[nLinha]:SetData(&("{|| X3Combo('"+SX3->X3_CAMPO+"',"+SX3->X3_CAMPO+")}") )
			EndIf

            aColumns[nLinha]:SetTitle(X3Titulo())
            aColumns[nLinha]:SetType(SX3->X3_TIPO)
            aColumns[nLinha]:SetSize(SX3->X3_TAMANHO)
            aColumns[nLinha]:SetDecimal(SX3->X3_DECIMAL)
            
        EndIf
        SX3->(DbSkip())	
    EndDo

    RestArea(aAreaSX3)
    aSize(aAreaSX3,0)

Return aColumns

//------------------------------------------------------------------------------
/*/{Protheus.doc} GetQuery
    Retorna as colunas utilizadas no browse

    @sample	    GetQuery(cAlias,aColumns)
    @param		Alias   , Caracter  , Alias temporario
    @param		aFields, Array     , Colunas utilizadas no Select
    @param		lMark   , Logico,   Adicionar coluna de Marcação	
    @return		cQuery  , Caracter  , Retorna Query

    @author		Danilo Salve
    @since		12/04/2018
    @version	1.0
/*/
//------------------------------------------------------------------------------
Static Function GetQuery(cAlias, aFields, lMark)

    Local cQuery    := " SELECT "
    Local nI        := 0

    Default cAlias  := ""
    Default aFields := {}
    Default lMark   := .F.

    If lMark
        cQuery += " '  ' MARK, "
    Endif

    If Len(aFields) > 0

        For nI := 1 To Len(aFields)
            cQuery += aFields[nI] + ", "
        Next nI

        cQuery := Substr(cQuery,1,Len(cQuery)-2)

    Else
        cQuery += " * "
    Endif    

    cQuery += " FROM " + RetSqlName(cAlias)
    cQuery += " WHERE D_E_L_E_T_ <> '*' "
    cQuery += " ORDER BY " + (cAlias)->(IndexKey())

    cQuery := ChangeQuery(cQuery)

Return cQuery

//------------------------------------------------------------------------------
/*/{Protheus.doc} SetMarK
    Marca/Desmarca registro do browse

    @sample	    GetIndex(cAlias)
    @param		Alias   , Caracter  , Alias temporario
    @param		cQuery  , Caracter  , Marca utilizada no Browse
    @return		Nulo

    @author		Danilo Salve
    @since		12/04/2018
    @version	1.0
/*/
//------------------------------------------------------------------------------

Static Function SetMarK(cAlias, cMarca)
	
	If !(cAlias)->(Eof())
		RecLock(cAlias, .F.)
		(cAlias)->MARK := IIf((cAlias)->MARK = cMarca,"  ",cMarca)
		MsUnlock(cAlias)
	EndIf

Return Nil