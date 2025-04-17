#INCLUDE "PROTHEUS.CH"
#INCLUDE "MATA410.CH"

//-----------------------------------------------------------
/*/{Protheus.doc} DSBrFwTmp
    Exemplo de utilização do objeto FwFormBrowse utilizando FWTemporaryTable

    @author Danilo Salve
    @since 12/04/2019
    @version 1.0
    @return Nulo
    @example DSFrMrkTmp()    
/*/
//-----------------------------------------------------------
Function DSBrFwTmp()
	Local aFields       := {}
	Local aColumns      := GetColumns( "SF1" , @aFields )
	Local aSeek	        := {}
	Local aIndex	    := GetIndex( "SF1" , @aSeek )
	Local aSize		    := FWGetDialogSize( oMainWnd )
	Local aStructSF1    := {{ "MARK","C",2,0 }}
	Local aStrtSF1      := SF1->( DBStruct() )
	Local bBtnForn      := {||IIF( A410Check( cAlias, cMarca ), ( MarkOk( cAlias ), oDlgDev:End() ), Help( "", 1, "HELP",, OemToAnsi( STR0187 ), 1, 0 ) ) }
	Local cAlias        := GetNextAlias()
	Local cAliasT       := GetNextAlias()
	Local cMarca	    := GetMark()
	Local cQuery        := GetQuery( "SF1", aFields, .T. )
	Local cIndex        := ""
	Local nX            := 0
	Local oDlgDev       := Nil
	Local oMBrowse      := Nil
	Local oTempTable    := Nil

	oTempTable := FWTemporaryTable():New( cAlias )

	For nX := 1 To Len( aStrtSF1 )
		aAdd(aStructSF1 ,  aStrtSF1[nX] )
	Next nX

	oTemptable:SetFields( aStructSF1 )

	For nX := 1 To Len( aIndex )
		oTempTable:AddIndex(cValtochar(aIndex[nX,1]), aIndex[nX,2] )
	Next nX

	oTempTable:Create()

	DBUseArea( .T., "TOPCONN", TcGenQry(,, cQuery ), cAliasT, .T., .T. )
	LoadTmp( oTempTable:GetRealName() , aStructSF1, cAliasT , cAlias )

	oDlgDev := MSDialog():New( aSize[1], aSize[2], aSize[3], aSize[4], OemToAnsi( STR0098 ) ,,,, nOr( WS_VISIBLE, WS_POPUP ),,,,, .T. ,,,, .T. ) //"Retorno de Doctos. de Entrada"
	oMBrowse := FWFormBrowse():New()
	oMBrowse:SetDescription( OemToAnsi( STR0098 ) ) //"Retorno de Doctos. de Entrada"
	oMBrowse:AddMarkColumn({|| IIF( ( cAlias )->MARK == cMarca, "LBOK", "LBNO") },{|| SetMarK( cAlias, cMarca ) },{|| SetMarkAll( cAlias, cMarca ) , oMBrowse:Refresh() })
	oMBrowse:SetOwner( oDlgDev )
	oMBrowse:SetDataQuery( .F. )
	oMBrowse:SetDataTable( .T. )
	oMBrowse:SetAlias( cAlias )
	oMBrowse:SetColumns( aColumns )
	oMBrowse:SetTemporary( .T. )
	oMBrowse:SetMenuDef( "" )
	oMBrowse:SetProfileID( "BRW_A410DEV" )
	oMBrowse:SetUseFilter( .T. )

	If Len(aSeek) > 0
		oMBrowse:SetSeek( Nil, aSeek )
	Endif

	oMBrowse:AddButton( OemtoAnsi(STR0053), bBtnForn, 0, 4, 0,,,,,{ OemtoAnsi( STR0053 ) }) //"Retornar"
	oMBrowse:DisableDetails()
	oMBrowse:DisableReports()
	oMBrowse:Activate()
	oDlgDev:Activate(,,,.T.)

	oTempTable:Delete()

	aSize( aFields, 0 )
	aSize( aColumns, 0 )
	aSize( aSeek, 0 )
	aSize( aIndex, 0 )
	aSize( aSize, 0 )
	aSize( aStructSF1, 0 )
	aSize( aStrtSF1, 0 )
	FreeObj( oMBrowse )
	FreeObj( oDlgDev )

Return Nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} GetColumns
    Retorna as colunas utilizadas no browse

    @sample	GetColumns(cAlias,.F.)
    @param		Alias   , Caractere, Alias temporario    
    @return		aColumns, Array,    Colunas do Browse
    @return		aFields , Array,    Campos do Browse

    @author		Danilo Salve
    @since		12/04/2018
    @version	1.0
/*/
//------------------------------------------------------------------------------
Static Function GetColumns( cAlias, aFields , lMark )
	Local aAreaSX3  := SX3->( GetArea() )
	Local aColumns  := {}
	Local nLinha    := 0

	Default lMark   := .F.
	Default aFields := {}

	If lMark
		aAdd(aColumns, FWBrwColumn():New() )
		aColumns[1]:SetData(&( "{ || MARK }") )
		aColumns[1]:SetTitle( "  " )
		aColumns[1]:SetType( "C" )
		aColumns[1]:SetSize( 2 )
		aColumns[1]:SetDecimal( 0 )
	Endif

	SX3->( DbSetOrder(1) )
	SX3->( DbSeek(cAlias) )
	While SX3->( !Eof() ) .And. SX3->X3_ARQUIVO == cAlias
		If X3Uso( SX3->X3_USADO ) .And. SX3->X3_BROWSE == "S" .And. SX3->X3_CONTEXT <> "V" .And. SX3->X3_TIPO <> "M"
			aAdd( aColumns, FWBrwColumn():New() )
			aAdd( aFields,SX3->X3_CAMPO )
			nLinha := Len( aColumns )

			If Empty(X3CBox())
				aColumns[nLinha]:SetData( &("{ || " + SX3->X3_CAMPO + " }" ))
			Else
				aColumns[nLinha]:SetData( &("{|| X3Combo('" + SX3->X3_CAMPO + "'," + SX3->X3_CAMPO+")}" ) )
			EndIf

			aColumns[nLinha]:SetTitle( X3Titulo() )
			aColumns[nLinha]:SetType( SX3->X3_TIPO )
			aColumns[nLinha]:SetSize( SX3->X3_TAMANHO )
			aColumns[nLinha]:SetDecimal( SX3->X3_DECIMAL )

		EndIf
		SX3->( DbSkip() )
	EndDo

	RestArea( aAreaSX3 )
	aSize( aAreaSX3,0 )
Return aColumns

//------------------------------------------------------------------------------
/*/{Protheus.doc} GetQuery
    Retorna as colunas utilizadas no browse

    @sample	    GetQuery(cAlias,aColumns)
    @param		Alias   , Caractere  , Alias temporario
    @param		aFields, Array     , Colunas utilizadas no Select
    @param		lMark   , Logico,   Adicionar coluna de Marcação	
    @return		cQuery  , Caractere  , Retorna Query

    @author		Danilo Salve
    @since		12/04/2018
    @version	1.0
/*/
//------------------------------------------------------------------------------
Static Function GetQuery( cAlias, aFields, lMark )
	Local cQuery    := " SELECT "
	Local nI        := 0

	Default cAlias  := ""
	Default aFields := {}
	Default lMark   := .F.

	If lMark
		cQuery += " '  ' MARK, "
	Endif

	If Len( aFields ) > 0

		For nI := 1 To Len( aFields )
			cQuery += aFields[ nI ] + ", "
		Next nI

		cQuery := Substr( cQuery, 1, Len( cQuery )-2 )

	Else
		cQuery += " * "
	Endif

	cQuery += " FROM " + RetSqlName( cAlias )
	cQuery += " WHERE F1_FILIAL = '" + xFilial( cAlias ) + "' "
	cQuery += " AND F1_FORNECE = '000002' "
	cQuery += " AND F1_LOJA    = '01' "
	cQuery += " AND F1_DTDIGIT >= '20190101' "
	cQuery += " AND F1_DTDIGIT <= '20191231' "
	cQuery += " AND F1_STATUS  <> '" + Space( Len( SF1->F1_STATUS ) ) + "' "
	cQuery += " AND F1_TIPO NOT IN ('D','B') "
	cQuery += " AND D_E_L_E_T_ <> '*' "
	cQuery += GetFilter()
	cQuery += " ORDER BY " + ( cAlias )->( IndexKey() )

	If Existblock("A410RNF")
		cQuery := ExecBlock("A410RNF",.F.,.F.,{ dDataDe, dDataAte, lForn, lFornece })
	EndIf

	cQuery := ChangeQuery( cQuery )
Return cQuery

//------------------------------------------------------------------------------
/*/{Protheus.doc} SetMarK
    Marca/Desmarca registro do browse

    @sample	    SetMarK(cAlias,cMarca)
    @param		Alias   , Caractere  , Alias temporario
    @param		cMarca  , Caractere  , Marca utilizada no Browse
    @return		Nulo

    @author		Danilo Salve
    @since		12/04/2018
    @version	1.0
/*/
//------------------------------------------------------------------------------
Static Function SetMarK( cAlias, cMarca )

	If ( cAlias )->( !Eof() )
		RecLock( cAlias, .F. )

		If Empty( ( cAlias )->MARK )
			( cAlias )->MARK := cMarca
		Else
			( cAlias )->MARK := "  "
		Endif

		( cAlias )->( MsUnLock() )
	Endif

Return Nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} SetMarkAll
    Marca/Desmarca todos registros do browse

    @sample	    SetMarkAll(cAlias,cMarca)
    @param		Alias   , Caractere  , Alias temporario
    @param		cMarca  , Caractere  , Marca utilizada no Browse
    @return		Nulo

    @author		Danilo Salve
    @since		16/04/2018
    @version	1.0
/*/
//------------------------------------------------------------------------------
Static Function SetMarkAll( cAlias, cMarca )

	Local aAreaTmp := ( cAlias )->( GetArea() )

	( cAlias )->( DbGoTop() )

	While ( cAlias )->( !Eof() )

		RecLock( cAlias, .F. )

		If Empty((cAlias)->MARK)
			( cAlias )->MARK := cMarca
		Else
			( cAlias )->MARK := "  "
		Endif

		( cAlias )->( MsUnLock() )
		( cAlias )->( DbSkip() )

	Enddo

	RestArea( aAreaTmp )
	aSize( aAreaTmp, 0 )

Return Nil

//------------------------------------------------------------------------------
/*/{Protheus.doc} GetFilter
    Retorna o filtro complementar do browse

    @sample	    GetFilter()
    @return		cFilter  , Caractere  , Retorna o Filtro da Query

    @author		Danilo Salve
    @since		15/04/2018
    @version	1.0
/*/
//------------------------------------------------------------------------------

Static Function GetFilter()

	Local cFilter	:= " "
	Local cConcat	:= "+"

	Local cFornece  := "000002"
	Local cLoja     := "01"

	If Upper(TcGetDb()) $ "ORACLE,POSTGRES,DB2,INFORMIX"
		cConcat := "||"
	Endif

	cFilter += " AND F1_FILIAL+F1_DOC+F1_SERIE NOT IN ( "
	cFilter += " SELECT D1_FILIAL "+ cConcat + " D1_DOC " + cConcat + " D1_SERIE FROM ( "
	cFilter += " SELECT D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, SUM(D1_QUANT) D1_QUANT "
	cFilter += " FROM " + RetSqlName( "SD1" )
	cFilter += " WHERE D1_FILIAL = '" + xFilial( "SD1" ) + "' "
	cFilter += " AND D1_FORNECE = '" + cFornece + "' "
	cFilter += " AND D1_LOJA = '" + cLoja    + "' "
	cFilter += " AND D_E_L_E_T_ <> '*' "
	cFilter += " GROUP BY  D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE "
	cFilter += " ) SD1 INNER JOIN ( "
	cFilter += " SELECT C6_FILIAL, C6_NFORI, C6_SERIORI, C6_CLI, SUM(C6_QTDVEN) C6_QTDVEN "
	cFilter += " FROM " + RetSqlName( "SC5" ) + " SC5 "
	cFilter += " INNER JOIN " + RetSqlName( "SC6" ) + " SC6 "
	cFilter += " ON C5_FILIAL = C6_FILIAL AND "
	cFilter += " C5_NUM = C6_NUM AND "
	cFilter += " SC5.D_E_L_E_T_ = SC6.D_E_L_E_T_ "
	cFilter += " WHERE C5_FILIAL = '" + xFilial( "SC5" ) + "' "
	cFilter += " AND C5_CLIENTE = '" + cFornece + "' "
	cFilter += " AND C5_LOJACLI = '" + cLoja    + "' "
	cFilter += " AND C5_TIPO = 'D' "
	cFilter += " AND SC5.D_E_L_E_T_ <> '*' "
	cFilter += " GROUP BY C6_FILIAL, C6_NFORI, C6_SERIORI , C6_CLI "
	cFilter += " ) SC6 "
	cFilter += " ON D1_FILIAL = C6_FILIAL AND D1_DOC = C6_NFORI AND D1_SERIE = C6_SERIORI "
	cFilter += " AND D1_FORNECE = C6_CLI AND D1_QUANT <= C6_QTDVEN ) "

Return cFilter

//------------------------------------------------------------------------------
/*/{Protheus.doc} A410Check
    Verifica se possui alguma seleção de NF

    @sample	    A410Check(cAlias,cMarca)
    @param		Alias    , Caractere , Alias temporario
    @param		cMarca   , Caractere , Adicionar coluna de Marcação    
    @return		lReturn  , Logico   , Retorna se existe alguma nota fiscal selecionada
    @author		Danilo Salve
    @since		15/04/2018
    @version	1.0
/*/
//------------------------------------------------------------------------------
Static Function A410Check( cAlias, cMarca )
	Local aAreaTmp  := ( cAlias )->( GetArea() )
	Local lReturn   := .F.

	( cAlias )->( DbGoTop() )

	While (cAlias)->(!Eof())

		If !Empty( (cAlias)->MARK )
			lReturn := .T.
			Exit
		Endif
		( cAlias )->( DbSkip() )

	Enddo

	RestArea( aAreaTmp )
	aSize( aAreaTmp, 0 )
Return lReturn

//------------------------------------------------------------------------------
/*/{Protheus.doc} GetIndex
    Retorna todos os indices utilizado em um Alias

    @sample	    GetIndex(cAlias,aSeek)
    @param		Alias    , Caractere , Alias temporario
    @param		aSeek    , Array    , Array utilizando no campo de Pesquisa do Browse
    @return		aIndex   , Array    , Array contendo todos os indices
    @author		Danilo Salve
    @since		16/04/2018
    @version	1.0
/*/
//------------------------------------------------------------------------------
Static Function GetIndex( cAlias, aSeek )
	Local aIndex    := {}
	Local aIndexTmp := {}
	Local aSeekTmp  := {}
	Local cIndex    := ""
	Local nX        := 1
	Local nY        := 0
	Local nAt       := 0
	Local nRat      := 0

	Default cAlias  := ""
	Default aSeek   := {}

	If FWAliasInDic( cAlias )
		cIndex := ( cAlias )->( IndexKey(nX) )
		While !Empty( cIndex )
			aIndexTmp := Separa( cIndex , "+" )
			For nY := 1 To Len( aIndexTmp )
				If "DTOS" $ aIndexTmp[nY]
					nRat := Rat("(" , aIndexTmp[3]) + 1
					nAt :=  At(")"  , aIndexTmp[3]) - nRat
					aIndexTmp[nY] := Substring( aIndexTmp[3] , nRat ,nAt )
				Endif
			Next nY
			aSeekTmp := GetSeek( aIndexTmp )

			If Len( aSeekTmp ) > 0
				aAdd( aSeek , aSeekTmp )
			Endif

			aAdd( aIndex , { nX++ , aIndexTmp })
			cIndex := ( cAlias )->( IndexKey(nX) )
		Enddo
	Endif
Return aIndex

//------------------------------------------------------------------------------
/*/{Protheus.doc} GetSeek
    Retorna todos os indices de Pesquisa

    @sample	    A410Check(cAlias,aSeek)
    @param		aIndex   , Array    , Array de campos do indice
    @return		aSeek    , Array    , Array utilizando no campo de Pesquisa do Browse
    @author		Danilo Salve
    @since		16/04/2018
    @version	1.0
/*/
//------------------------------------------------------------------------------
Static Function GetSeek(aIndex)
	Local aSeek     := {}
	Local aAreaSX3  := SX3->( GetArea() )
	Local cNome     := ""
	Local nDecimal  := 0
	Local nI        := 0
	Local nTamanho  := 0

	For nI := 1 To Len( aIndex )
		DbSelectArea( "SX3" )
		SX3->( DbSetOrder(2) )
		If MsSeek( aIndex[nI] )
			cNome += Alltrim( X3Titulo() ) + "+"
			nTamanho += SX3->X3_TAMANHO
			nDecimal += SX3->X3_DECIMAL
		Endif
	Next nI

	If !Empty(cNome)
		cNome := Substring( cNome, 1, Len(cNome) - 1 )
	Endif

	aSeek := { cNome, {{"", "C", nTamanho, nDecimal, cNome,,}}}

	RestArea( aAreaSX3 )
	aSize( aAreaSX3, 0 )
Return aSeek

//------------------------------------------------------------------
/*/{Protheus.doc} MarkOk
Esta Função tem como objetivo verificar a ação ao clicar no botão retornar
no pedido de vendas

@param		cAlias, Caractere, Alias
@author 	Squad CRM
@since 		16/04/2019
@version 	P12
@return 	Nulo
/*/
//-------------------------------------------------------------------
Static Function MarkOk( cAlias )
	Local aAreaTmp  := ( cAlias )->( GetArea() )
	Local cDocSF1   := " "

	(cAlias)->(DbGoTop())

	While ( cAlias )->( !Eof() )

		If !Empty((cAlias)->MARK)
			cDocSF1 += "( SD1.D1_DOC = '" + ( cAlias )->F1_DOC + "' AND SD1.D1_SERIE = '" + ( cAlias )->F1_SERIE + "' ) OR "
		Endif

		(cAlias)->(DbSkip())

	Enddo

	If !Empty( cDocSF1 )
		cDocSF1 := SubStr( cDocSF1 , 1, Len( cDocSF1 ) -3 ) + " )"
	EndIf

	RestArea( aAreaTmp )
	aSize( aAreaTmp, 0 )
Return Nil

//------------------------------------------------------------------
/*/{Protheus.doc} LoadTmp
Esta Função tem como objetivo carregar os dados da tabela temporaria

@param		cAliasTmp   , Caractere  , Nome do Alias criado na Tabela temporaria
@param		aStructSF1  , Array     , Estrutura dos campos na SF1
@param		cAliasT     , Caractere  , Alias
@author 	Squad CRM
@since 		18/04/2019
@version 	P12
@return 	Nulo
/*/
//-------------------------------------------------------------------
Static Function LoadTmp( cAliasTmp , aStructSF1, cAliasT , cAlias)
	Local aStructTmp    := ( cAliasT )->( DBStruct() )
	Local cSQLInsert    := ""
	Local nPos          := 0
	Local nX            := 0

	For nX := 1 To Len( aStructSF1 )
		If aStructSF1[nX][2] $ "D#L#N"
			TCSetField( cAliasT, aStructSF1[ nX, 1 ], aStructSF1[ nX, 2 ], aStructSF1[ nX, 3 ], aStructSF1[ nX, 4 ] )
		EndIf
	Next nX

	If TCGetDB() != "MSSQL"
		cSQLInsert += " INSERT INTO " + cAliasTmp + " ( "

		For nX := 1 To Len( aStructTmp )
			cSQLInsert += aStructTmp[ nX,1 ] + ", "
		Next nX

		If !Empty( cSQLInsert )
			cSQLInsert := Substring(cSQLInsert,1,Len(cSQLInsert)-2)
		Endif

		cSQLInsert += " ) VALUES "

		While (cAliasT)->( !Eof() )
			cSQLInsert += "( "
			For nX := 1 To Len(aStructSF1)
				nPos := aScan( aStructTmp, { |x| AllTrim( x[1] ) == AllTrim( aStructSF1[ nX,1 ] )})
				If nPos > 0
					If ValType(( cAliasT )->( FieldGet( nPos ) )) == "N"
						cSQLInsert +=  "'"   + CValToChar( ( cAliasT )->( FieldGet( nPos ) ) ) + "',"
					ElseIf ValType(( cAliasT )->( FieldGet( nPos ) )) == "D"
						cSQLInsert +=  "'"   + DtoS( ( cAliasT )->( FieldGet( nPos ) ) ) + "',"
					Else
						cSQLInsert +=  "'"   + ( cAliasT )->( FieldGet( nPos ) ) + "',"
					Endif
				Endif
			Next nX

			cSQLInsert := Substring(cSQLInsert,1,Len(cSQLInsert)-1) + " ), "
			( cAliasT )->( DbSkip() )
		Enddo

		cSQLInsert := Substring(cSQLInsert,1,Len(cSQLInsert)-2)
		nRet := TCSQLExec( cSQLInsert )

		If nRet < 0
			MsgStop( TCSqlError() )
		EndIf

	Else

		While (cAliasT)->( !Eof() )
			RecLock( cAlias, .T.)
			nLen := Len( aStructSF1 )
			For nX := 1 To nLen
				nPos := aScan(aStructTmp,{|x| AllTrim( x[1] ) == AllTrim(aStructSF1[nX][1])})
				If nPos > 0
					(cAlias)->( FieldPut( nX, (cAliasT)->( FieldGet(nPos) ) ) )
				EndIf
			Next nX
			( cAlias )->( MsUnlock() )

			(cAliasT)->( DBSkip() )
		Enddo
	Endif

	aSize( aStructTmp, 0 )
Return Nil
