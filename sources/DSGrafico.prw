#INCLUDE "PRCONST.CH"
#INCLUDE "PROTHEUS.CH"

User Function DSGrafico()
	Local oFWChart
	Local oDlg

	DEFINE MSDIALOG oDlg PIXEL FROM 10,0 TO 600,400
        oFWChart := FWChartFactory():New()
        oFWChart := oFWChart:getInstance( BARCHART )

    // cria objeto FWChartBar
    /*Valores do getInstance:BARCHART  -  cria objeto 
    FWChartBarBARCOMPCHART -  cria objeto 
    FWChartBarCompLINECHART -  cria objeto 
    FWChartLinePIECHART - cria objeto FWChartPie*/

        oFWChart:init( oDLG, .F. )
        oFWChart:setTitle( "Titulo do grafico", CONTROL_ALIGN_CENTER )
        oFWChart:setLegend( CONTROL_ALIGN_LEFT )
        oFWChart:setMask( "R$ *@* " )
        oFWChart:setPicture( "@E 99.99" )
        oFWChart:addSerie( "Série 01", 10 )
        oFWChart:addSerie( "Série 02", 2 )
        oFWChart:build()
    ACTIVATE MSDIALOG oDlg

Return
