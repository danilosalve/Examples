#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} DSMsGet
    Exemplo de MsGet ofuscando dados protegidos.

    @sample     DSMsGet()    
    @return     Nulo
    @author 	Danilo Salve
    @version	v1.0
    @since		27/11/2019
/*/
//-------------------------------------------------------------------
Function DSMsGet()
    
    Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7
    Local nOpca     as Numeric
    Local oDlg      as Object
    Local oGetCod   as Object
    Local oMsGet    as Object
    Local oMsGetD   as Object
    Local oMsGetN   as Object
    Local oMsGeF3   as Object
    Local lPdCodigo := .F.
    Local lPdNome   := .F.
    Local lPdCGC    := .F.
    Local lPdDtNasc := .F.
    Local lPdLC     := .F.

    Private cCodigo := "xFATPD"
    Private cNome   := "TESTE DADO PROTEGIDO"
    Private cCGC    := "00000000000000"
    Private cCliente:= Space(6)
    Private nLC     := 1
    Private dDate   := Date()
    Private nNumero := 1000

    Private oGet      as Object    
    
    DEFINE MSDIALOG oDlg TITLE oEmToAnsi("Teste MSGET") FROM 000,000 TO 300,300 PIXEL 
    
    @ 001,001 TO 150, 152 OF oDlg PIXEL

    If VerSenha(192) .Or. VerSenha(193)
        cUsuario := "Usuario com acesso a dados protegidos."
    Else
        cUsuario := "Usuario sem acesso a dados protegidos."
    Endif

    @ 010,010 SAY oSay1  PROMPT cUsuario SIZE 100, 07 COLORS CLR_RED,CLR_WHITE OF oDlg PIXEL
    
    @ 030,010 SAY oSay2 PROMPT oEmToAnsi("Não Ofusca:") SIZE 55, 07 OF oDlg PIXEL
    @ 030,050 MSGET oGetCod VAR cCodigo SIZE 50, 08 OF oDlg PIXEL VALID !Vazio() WHEN !lPdCodigo
    oGetCod:lObfuscate := lPdCodigo    
    
    @ 050,010 SAY oSay3 PROMPT oEmToAnsi("MSGET Texto:")  SIZE 55, 07 OF oDlg PIXEL 
    @ 050,050 MSGET oMsGet Var cNome    SIZE 55, 11 OF oDlg PIXEL VALID !Vazio() WHEN !lPdNome VALID Texto()
    oMsGet:lObfuscate := lPdNome
    
    @ 070,010 SAY oSay4 PROMPT oEmToAnsi("GET PIC:") SIZE 55, 07 OF oDlg PIXEL
    @ 070,050 MSGET oGet Var cCGC      SIZE 55, 11 OF oDlg PIXEL PICTURE "@R 99.999.999/9999-99" VALID !Vazio() OBFUSCATED lPdCGC WHEN !lPdCGC
        
    @ 090,010 SAY oSay5 PROMPT oEmToAnsi("Get Data:") SIZE 55, 07 OF oDlg PIXEL
    @ 090,050 MSGET oMsGetD Var dDate     SIZE 55, 11 OF oDlg PIXEL  WHEN !lPdDtNasc HASBUTTON
    oMsGetD:lObfuscate := lPdDtNasc
    
    @ 110,010 SAY oSay6 PROMPT oEmToAnsi("Get Numerico:") SIZE 55, 07 OF oDlg PIXEL
    @ 110,050 MSGET oMsGetN Var nNumero       SIZE 55, 11 OF oDlg PIXEL PICTURE "@E 999,999,999" Valid !Vazio() WHEN !lPdLC
    oMsGetN:lObfuscate := lPdLC    
    
    @ 130,010 SAY oSay7 PROMPT oEmToAnsi("Get F3:") SIZE 55, 07 OF oDlg PIXEL
    @ 130,050 MSGET oMsGeF3 Var cCliente SIZE 55, 11 OF oDlg PIXEL  WHEN !lPdDtNasc HASBUTTON F3 "SA1"

    DEFINE SBUTTON FROM 010, 120 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
    DEFINE SBUTTON FROM 025, 120 TYPE 2 ACTION (nOpca := 2,oDlg:End()) ENABLE OF oDlg    
    DEFINE SBUTTON FROM 040, 120 TYPE 11 ACTION (lVerPD(@lPdCGC) ,oGet:Refresh()) ENABLE OF oDlg        
    ACTIVATE MSDIALOG oDlg CENTERED

Return Nil

//-------------------------------------------------------------------
/*/{Protheus.doc} lVerPD
    Valida dados ref. a proteção de dados.

    @sample     VerPD(lPdCGC)  
    @return     Logico, lPDCGC, Retornar se campo pode ser editado.
    @author 	Danilo Salve
    @version	v1.0
    @since		27/11/2019
/*/
//-------------------------------------------------------------------
Static Function lVerPD(lPdCGC)    

    If lPdCGC
        lPdCGC := .F.
    Else
        lPdCGC := .T.
    Endif

Return lPdCGC