#INCLUDE "PROTHEUS.CH"

Main Function DSORC()
    RpcSetEnv( "T1", "D MG 01 ", "ADMIN" )
    MyMata415()
    RpcClearEnv()
return nil

Function MyMata415()
	Local aCabec := {}
	Local aItens := {}
	Local aLinha := {}
	Local cDoc   := ""
	private lMsErroAuto := .F.

	ConOut(Repl("-",80))
	ConOut(PadC("Teste de Inclusao de 10 orcamentos de venda  com 30 itens cada", 80))
	ConOut("Inicio: "+Time())

	cDoc := GetSxeNum("SCJ","CJ_NUM")
	RollBAckSx8()
	aCabec := {}
	aItens := {}
	aadd(aCabec,{"CJ_NUM"       , cDoc      , Nil})
	aadd(aCabec,{"CJ_CLIENTE"   , '000004'  , Nil})
	aadd(aCabec,{"CJ_LOJA"      , '01'      , Nil})
	aadd(aCabec,{"CJ_LOJAENT"   , '01'      , Nil})
	aadd(aCabec,{"CJ_CONDPAG"	, '001'     , Nil})
	aadd(aCabec,{"CJ_PROSPE"	, '      '  , Nil})
	aadd(aCabec,{"CJ_LOJPRO"	, '  '      , Nil})

	aCabec := FwVetByDic(aCabec, "SCJ", .F.)

	aadd(aLinha,{"CK_ITEM"      , '01'      , Nil})
	aadd(aLinha,{"CK_PRODUTO"   , '000000000000005', Nil})
	aadd(aLinha,{"CK_QTDVEN"    , 1         , Nil})
	aadd(aLinha,{"CK_PRCVEN"    , 3.99      , Nil})
	aadd(aLinha,{"CK_PRUNIT"    , 3.99      , Nil})
	aadd(aLinha,{"CK_VALOR"     , 3.99      , Nil})
	aadd(aLinha,{"CK_OPER"      , '01'      , Nil})
	aadd(aItens,aLinha)

	aLinha := {}
	aadd(aLinha,{"CK_ITEM"      , '02'      , Nil})
	aadd(aLinha,{"CK_PRODUTO"   , '000000000000018', Nil})
	aadd(aLinha,{"CK_QTDVEN"    , 1          , Nil})
	aadd(aLinha,{"CK_PRCVEN"    , 10.99       , Nil})
	aadd(aLinha,{"CK_PRUNIT"    , 10.99      , Nil})
	aadd(aLinha,{"CK_VALOR"     , 10.99       , Nil})
	aadd(aLinha,{"CK_OPER"      , '01'       , Nil})
	aadd(aItens,aLinha)

	aLinha := {}
	aadd(aLinha,{"CK_ITEM"      , '03'      , Nil})
	aadd(aLinha,{"CK_PRODUTO"   , '000000000000008', Nil})
	aadd(aLinha,{"CK_QTDVEN"    , 1          , Nil})
	aadd(aLinha,{"CK_PRCVEN"    , 24.88       , Nil})
	aadd(aLinha,{"CK_PRUNIT"    , 24.88      , Nil})
	aadd(aLinha,{"CK_VALOR"     , 24.88       , Nil})
	aadd(aLinha,{"CK_OPER"      , '01'       , Nil})
	aadd(aItens,aLinha)
	aCabec := FwVetByDic(aItens, "SCK", .T.)

	MATA415(aCabec,aItens, 3)

	If !lMsErroAuto
		ConOut("Incluido com sucesso! "+cDoc)
	Else
		ConOut("Erro na inclusao!")
	EndIf
return
