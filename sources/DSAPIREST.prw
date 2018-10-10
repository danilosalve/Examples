#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "RESTFUL.CH"

WSRESTFUL dsapirest DESCRIPTION "Classe RESTFUL DSAPIREST" 

	WSDATA Fields			AS STRING	OPTIONAL
	WSDATA Order			AS STRING	OPTIONAL
	WSDATA Page				AS INTEGER	OPTIONAL
	WSDATA PageSize			AS INTEGER	OPTIONAL
	WSDATA Code			    AS STRING	OPTIONAL
	
    WSMETHOD GET Main ;
    DESCRIPTION "Retorna todos Apontamentos" ;
    WSSYNTAX "/dsapirest/{Order, Page, PageSize, Fields}" ;
    PATH "/dsapirest"

ENDWSRESTFUL

/*/{Protheus.doc} GET Main dsapirest
Retorna lista com objeto Json

@param	Order		, caracter, Ordenação da tabela principal
@param	Page		, numérico, Número da página inicial da consulta
@param	PageSize	, numúrico, Número de registro por páginas
@param	Fields		, caracter, Campos que serão retornados na requisição.

@return lRet	    , Lógico, Informa se o processo foi executado com sucesso.

@author		Danilo Salve
@since		09/10/2018
@version	12.1.17
/*/

WSMETHOD GET Main WSRECEIVE Order, Page, PageSize, Fields WSSERVICE dsapirest
	
    Local lRet	:= .T.
	Local oJson	:= JsonObject():New()
	Local oJson2:= JsonObject():New()
	Local oJson3:= JsonObject():New()

	oJson['Author']		:= "000001"
	oJson['FirstName'] 	:= "Danilo"
	oJson['NickName'] 	:= "Alladin"
	oJson['Date'] 		:= dDataBase
	oJson['Time'] 		:= Time()
	oJson['Games'] := {}
	oJson2['Name'] 		:= "FIFA 19"
	oJson2['Genre'] 	:= "Sports"	
	oJson3['Name'] 		:= "GTA V"
	oJson3['Genre'] 	:= "Action"
	aAdd(oJson['Games'], oJson2)
	aAdd(oJson['Games'], oJson3)
	
    Self:SetResponse( EncodeUtf8(FwJsonSerialize(oJson ,.T.,.T.)))

Return lRet