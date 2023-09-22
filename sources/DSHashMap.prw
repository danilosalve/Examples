#INCLUDE "PROTHEUS.CH"

//------------------------------------------------------------------
/*/{Protheus.doc} DSHashMap()
Exemplo de utlização da Classe THashMap

@author 	Danilo Salve
@since 		29/05/2019
/*/
//-------------------------------------------------------------------

Function DSHashMap()

    Local aArray := {}
    Local cKey   := ""
    Local lRet   := .T.
    Local nI     := 0
    Local oHash  := Nil
    Local oList  := Nil    
    Local xVal   := Nil    

    oHash := THashMap():New()
    //Set - Atualiza o valor correspondente a chave.
    oHash:Set( "Brasil"      , 5 )
    oHash:Set( "Italia"      , 4 )
    oHash:Set( "Alemanha"    , 4 )
    oHash:Set( "Argentina"   , 3 )
    oHash:Set( "França"      , 2 )
    oHash:Set( "Uruguai"     , 2 )
    oHash:Set( "Estados_Unidos_da_America"  , 0 )
    
    If oHash:List( oList )       

        For nI := 1 To Len( oList )
            cKey := oList[ nI, 1 ]
            // Get - Obtém o valor armazenado correspondente a chave.
            oHash:Get( cKey ,xVal )
            If ValType( xVal ) == "N"
                Conout( oList[ nI, 1 ] + ": " + CValToChar( xVal ) )
            Endif
        Next nI
        //Remove o valor armazenado correspondente a chave
        cKey := "Paraguai"
        lRet := oHash:Del( cKey )
    Endif

    //Limpa o Objeto
    oHash:Clean()
    FreeObj( oList )

    AAdd( aArray, { "Holanda"    , 0 } )
    AAdd( aArray, { "Inglaterra" , 1 } )
    // Converte uma matriz de dados ( Array ) em um tHashMap, podendo combinar as colunas para a chave de busca.
    oHash := AToHM( aArray )

    If oHash:List( oList )
        For nI := 1 To Len( oList )
            cKey := oList[ nI, 1 ]
            // Get - Obtém o valor armazenado correspondente a chave.
            oHash:Get( cKey ,xVal )
            If ValType( xVal ) == "A" .And. Valtype( xVal[ 1 , 2] ) == "N"
                Conout( xVal[ 1 , 1] + ": " + CValToChar( xVal[ 1 , 2] ) )
            Endif
        Next nI
    Endif

    ASize( aArray, 0 )
    FreeObj( oList )
    FreeObj( oHash )

Return Nil
