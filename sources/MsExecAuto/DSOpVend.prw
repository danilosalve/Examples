#Include "Protheus.CH"
#INCLUDE "TBICONN.CH"
//------------------------------------------------------------------
/*/{Protheus.doc} DSOpVend()
	Exemplo ExecAuto Oportunidade de Venda.

    @sample	    DSOpVend() 
    @return		Nulo    , Nulo  	, Nulo

    @author		Danilo Salve
    @since		30/04/2019
    @version	1.0
/*/
//-------------------------------------------------------------------
User Function DSOpVend()	
	
	Local aCabec			:= {}

	Private lMsErroAuto 	:= .f.
	
	ConOut( Repl( "-", 80 ) )
	ConOut( PadC( " Teste de Inclusao de Oportunidade de Venda ", 80 ) )
	ConOut( " Inicio Teste: " + Time(), 80 ) )
	ConOut( Repl( "-", 80 ) )
		
	aAdd( aCabec, { "AD1_REVISA"	, "01"		           	, NIL } )
	aAdd( aCabec, { "AD1_DESCRI"	, "Teste MSExecAuto" 	, NIL } )
	aAdd( aCabec, { "AD1_DATA  "	, Date()             	, NIL } )
	aAdd( aCabec, { "AD1_HORA  "	, SubStr( Time(), 1, 5 ), NIL } )
	aAdd( aCabec, { "AD1_USER  "	, "000003"     	        , NIL } )
	aAdd( aCabec, { "AD1_VEND  "	, "000003"     		    , NIL } )
	aAdd( aCabec, { "AD1_NOMVEN"	, "VENDEDOR O1"         , NIL } )
	aAdd( aCabec, { "AD1_DTINI "	, Date()                , NIL } )
	aAdd( aCabec, { "AD1_CODCLI"	, "000005"				, Nil } )
	aAdd( aCabec, { "AD1_LOJCLI"	, "01"					, Nil } )
	aAdd( aCabec, { "AD1_PROVEN"	, "000001"		        , NIL } )
	aAdd( aCabec, { "AD1_STAGE "	, "000001"		        , NIL } )
	aAdd( aCabec, { "AD1_MOEDA "	, 1		                , NIL } )
	aAdd( aCabec, { "AD1_PRIOR "	, "1"		            , NIL } )
	
	MSExecAuto( {| x,y | FATA300( x, y ) }, 3, aCabec )

	If lMsErroAuto
		 If !IsBlind()
			MostraErro()
		Else
			ConOut( " Erro na inclusao ! " )
		Endif
	Else
		ConOut(" Incluido com sucesso ! ")
	EndIf
	
	ConOut( Repl( "-", 80 ) )
	ConOut( PadC( " Fim teste: " + Time() , 80 ) )
	ConOut( Repl( "-", 80 ) )
	
	aSize( aCabec, 0 )
	
Return Nil
