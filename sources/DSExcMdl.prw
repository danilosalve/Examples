#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

/*/{Protheus.doc} DSExcMdl
Exemplo de chamada de FWExecModalView
@author     Danilo Salve
@since      01/10/2018
@version    1.0
@Example   	DSExcMdl
http://tdn.totvs.com/display/framework/FWExecModalView
/*/
Function DSExcMdl()
	Private oBrowse := FwMBrowse():New()
	Private aRotina := MenuDef()
	
	oBrowse:SetAlias("AD1")
	oBrowse:SetDescription("Teste Modal")
	oBrowse:Activate()
	
Return Nil

Static Function Menudef()
	Private aRotina := {}

	aRotina	:= {{OemToAnsi("Rapida"),"AD1FAST()",0,3}}	//Oportunidade Rapida
Return aRotina

Function AD1FAST()
	FWExecModalView( 'Oportunidade Rápida', 'FATA300',3, { || .T. }, { || .T. },,600 )
Return Nil
