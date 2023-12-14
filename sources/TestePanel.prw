#INCLUDE "PROTHEUS.CH"

//------------------------------------------------------------------
/*/{Protheus.doc} TestePanel()
Teste Dialog com Panel

@author 	Danilo Salve
@since 		13/05/2019
/*/
//-------------------------------------------------------------------

Function TestePanel()

    Local cTGet01       := Space(60)
    Local oTButton1     := Nil
    Local oCheck01      := Nil
    Local oCheck02      := Nil
    Local oCheck03      := Nil
    Local oCheck04      := Nil
    Local oCheck05      := Nil
    Local oCheck06      := Nil
    Local oCheck07      := Nil
    Local oCheck08      := Nil
    Local oCheck09      := Nil
    Local oCheck10      := Nil
    Local oDlg          := Nil
    Local oGroup01      := Nil
    Local oGroup02      := Nil
    Local oGroup03      := Nil
    Local oPanel01      := Nil
    Local oPanel02      := Nil
    Local oPanel03      := Nil
    Local oTGet01       := Nil
    Local lCheck01      := .F.
    Local lCheck02      := .F.
    Local lCheck03      := .F.
    Local lCheck04      := .F.
    Local lCheck05      := .F.
    Local lCheck06      := .F.
    Local lCheck07      := .F.
    Local lCheck08      := .F.
    Local lCheck09      := .F.
    Local lCheck10      := .F.    

    oDlg := MSDialog():New( 010, 010, 600, 450, "Teste Panel" ,,,,,,,,, .T. )
    oPanel01:= TPanel():New( 001, 001, "Panel1", oDlg,, .T. ,,,CLR_HCYAN,225,065,.T.,.T.)
    oGroup01 := TGroup():New( 010, 002, 060, 220, "Objeto TGroup 01", oPanel01,,, .T. )
    oCheck01 := TCheckBox():New( 020, 010, "Teste",{ |u| if(PCount()>0, lCheck01:=u, lCheck01) }, oGroup01, 050, 010,,,,,,,,.T.,,,)
    oCheck02 := TCheckBox():New( 030, 010, "Teste",{ |u| if(PCount()>0, lCheck02:=u, lCheck02) }, oGroup01, 050, 010,,,,,,,,.T.,,,)
    oTGet01  := TGet():New( 040, 010, {|| cTGet01 }, oGroup01, 210, 009, "@!",, 0,,, .F.,, .T.,, .F.,, .F., .F.,, .F., .F.,, cTGet01,,,,,,, "Teste", 1,,, "Teste")
    oGroup02 := TGroup():New( 070, 002, 120, 220, "Objeto TGroup 02", oDlg,,, .T. )
    oCheck03 := TCheckBox():New( 080, 010, "Teste",{ |u| if(PCount()>0, lCheck03:=u, lCheck03) }, oGroup02, 050, 010,,,,,,,,.T.,,,)    	                                                
    oCheck04 := TCheckBox():New( 100, 010, "Teste",{ |u| if(PCount()>0, lCheck04:=u, lCheck04)}, oGroup02, 050, 010,,,,,,,,.T.,,,)    
    oCheck05 := TCheckBox():New( 125, 010, "Teste",{ |u| if(PCount()>0, lCheck05:=u, lCheck05) }, oDlg, 050, 010,,,,,,,,.T.,,,)
    oCheck06 := TCheckBox():New( 135, 010, "Teste",{ |u| if(PCount()>0, lCheck06:=u, lCheck06) }, oDlg, 050, 010,,,,,,,,.T.,,,)    
    oPanel02:= TPanel():New( 145, 001, "Panel2", oDlg,, .T. ,,,CLR_HBLUE,225,065,.T.,.T.)
    oGroup03 := TGroup():New( 001, 002, 060, 220, "Objeto TGroup 03", oPanel02,,, .T. )
    oCheck07 := TCheckBox():New( 020, 010, "Teste",{ |u| if(PCount()>0, lCheck07:=u, lCheck07) }, oGroup03, 050, 010,,,,,CLR_WHITE,,,.T.,,,)
    oCheck08 := TCheckBox():New( 030, 010, "Teste",{ |u| if(PCount()>0, lCheck08:=u, lCheck08) }, oGroup03, 050, 010,,,,,CLR_HRED,,,.T.,,,)
    oPanel03:= TPanel():New( 210, 001, "Panel3", oDlg,, .T. ,,,CLR_HGRAY,225,045,.T.,.T.)    
    oCheck09 := TCheckBox():New( 015, 010, "Teste",{ |u| if(PCount()>0, lCheck09:=u, lCheck09) }, oPanel03, 050, 010,,,,,,,,.T.,,,)
    oCheck10 := TCheckBox():New( 025, 010, "Teste",{ |u| if(PCount()>0, lCheck10:=u, lCheck10) }, oPanel03, 050, 010,,,,,,,,.T.,,,)    
    oTButton1 := TButton():New( 265, 010, "Sair" , oDlg, { || oDlg:End() }, 040, 010,,,.F.,.T.,.F.,,.F.,,,.F. )
    
    oDlg:Activate(,,, .T. ,,,)    
    Freeobj(oTButton1)
    Freeobj(oTGet01)
    Freeobj(oPanel03)
    Freeobj(oPanel02)
    Freeobj(oPanel01)
    Freeobj(oCheck10)
    Freeobj(oCheck09)
    Freeobj(oCheck08)
    Freeobj(oCheck07)
    Freeobj(oCheck06)
    Freeobj(oCheck05)
    Freeobj(oCheck04)
    Freeobj(oCheck03)
    Freeobj(oCheck02)
    Freeobj(oCheck01)
    Freeobj(oGroup03)
    Freeobj(oGroup02)
    Freeobj(oGroup01)
    Freeobj(oDlg)

Return Nil
