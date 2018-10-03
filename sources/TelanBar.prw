#include 'protheus.ch'

user function TelanBar()
	Local oDlgTst
	Local oBar
	Local oBtnCalc
	Local oBtnPar
	Local oBtnOk

	oDlgTst  := MsDialog():New(000,000,305,505, 'Exemplo -BUTTONBAR',,,,,,,,,.T.)
	
	DEFINE BUTTONBAR oBar SIZE 25,25 3D TOP OF oDlgTst

	//Criando botões pertencentes a barra de botões
	DEFINE BUTTON           RESOURCE "S4WB005N"      OF oBar          ACTION NaoDisp()      TOOLTIP "Recortar"
	DEFINE BUTTON           RESOURCE "S4WB006N"      OF oBar          ACTION NaoDisp()      TOOLTIP "Copiar"
	DEFINE BUTTON           RESOURCE "S4WB007N"      OF oBar          ACTION NaoDisp()      TOOLTIP "Colar"
	DEFINE BUTTON oBtnCalc  RESOURCE "S4WB008N"      OF oBar GROUP    ACTION Calculadora()  TOOLTIP "Calculadora"
	DEFINE BUTTON           RESOURCE "S4WB009N"      OF oBar          ACTION Agenda()       TOOLTIP "Agenda"
	DEFINE BUTTON           RESOURCE "S4WB010N"      OF oBar          ACTION OurSpool()     TOOLTIP "Spool"
	DEFINE BUTTON           RESOURCE "S4WB016N"      OF oBar GROUP    ACTION HelProg()      TOOLTIP "Ajuda"
	DEFINE BUTTON oBtnPar   RESOURCE "PARAMETROS"    OF oBar GROUP    ACTION Sx1C020()      TOOLTIP "Parâmetros"
	DEFINE BUTTON oBtnOk    RESOURCE "FINAL"         OF oBar GROUP    ACTION oDlgTst:End()  TOOLTIP "Sair"

	//Definindo título de alguns botões
	oBtnCalc:cTitle := "Calc"
	oBtnPar:cTitle  := "Param."

	//Definindo clique com o botão direito
	oBar:bRClicked := {|| AllwaysTrue()}

	oDlgTst:lCentered := .T.
	oDlgTst:Activate()

Return Nil