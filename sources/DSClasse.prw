#Include 'Protheus.ch'

//-----------------------------------------------------------
/*/{Protheus.doc} DSClasse
    Exemplo de utilização d Classe

    @author Danilo Salve
    @since 03/05/2019
    @version 1.0    
    @example DSClasse():New()
/*/
//-----------------------------------------------------------
Class DSClasse

    Data aEndereco     As Array
    Data cNome         As Character
    Data cSobrenome    As Character
	Data nIdade        As Numeric
    Data lActive       As Logical

    Method New() Constructor
    Method Activate()
	Method IsActive()
    Method Load()

EndClass

//-----------------------------------------------------------
/*/{Protheus.doc} New
    Metodo Construtor

    @author Danilo Salve
    @since 03/05/2019
    @version 1.0
    @example DSClasse():New()
/*/
//-----------------------------------------------------------
Method New() Class DSClasse
	
    Self:aEndereco  := {}
    Self:cNome      := ""
    Self:cSobreNome := ""
    Self:nIdade     := 0
	Self:lActive    := .F.

Return Self

//-----------------------------------------------------------
/*/{Protheus.doc} Activate
    Metodo responsavel por ativar a classe

    @author Danilo Salve
    @since 03/05/2019
    @version 1.0
    @example DSClasse:Activate()
/*/
//-----------------------------------------------------------
Method Activate() Class DSClasse

    If !Self:IsActive()
        Self:lActive := .T.
    Endif

Return Nil

//-----------------------------------------------------------
/*/{Protheus.doc} IsActive
    Metodo responsavel validar se a classe está ativa

    @author Danilo Salve
    @since 03/05/2019
    @version 1.0
    @example DSClasse:Activate()
/*/
//-----------------------------------------------------------
Method IsActive() Class DSClasse

Return Self:lActive

//-----------------------------------------------------------
/*/{Protheus.doc} Load
    Metodo responsavel carregar os dados na classe

    @author Danilo Salve
    @since 03/05/2019
    @version 1.0
    @example DSClasse:Load( {"Rua João Amado Coutinho",121,"Apto 23 Bloco A"}, "Danilo","Salve",29)
/*/
//-----------------------------------------------------------
Method Load( aEndereco, cNome, cSobreNome, nIdade) Class DSClasse

    Local lRet  := .T.

    Default aEndereco   := {}
    Default cNome       := ""
    Default cSobreNome  := ""
    Default nIdade      := 0

    If Self:IsActive()
        Self:aEndereco  := aEndereco
        Self:cNome      := cNome
        Self:cSobreNome := cSobreNome
        Self:nIdade     := nIdade  
    Else
        lRet  := .F.                
    Endif

Return lRet