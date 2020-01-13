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
Class DSClasse from longnameclass
/*
    Ao herdar de longnameclass, perdemos a limitação de dez caracteres, 
    mas temos um ponto de atenção muito importante! 
    Se herdamos novamente a nossa classe, perdemos essa limitação, 
    portanto CUIDADO!
*/
    Data aEndereco     As Array
    Data cNome         As Character
    Data cSobrenome    As Character
	Data nIdade        As Numeric
    Data lActive       As Logical

    Method New() Constructor
    Method Activate()
	Method IsActive()
    Method Destroy()

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
Method New( aEndereco, cNome, cSobreNome, nIdade ) Class DSClasse

    Default aEndereco   := {}
    Default cNome       := ""
    Default cSobreNome  := ""
    Default nIdade      := 0
    
    Self:aEndereco  := aEndereco
    Self:cNome      := cNome
    Self:cSobreNome := cSobreNome
    Self:nIdade     := nIdade  
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
/*/{Protheus.doc} IsActive
    Metodo responsavel por destroir o objeto.

    @author Danilo Salve
    @since 09/01/2020
    @version 1.0
    @example DSClasse:Destroy()
/*/
//-----------------------------------------------------------
Method Destroy() Class DSClasse

    aSize(Self:aEndereco, 0)
    Self:aEndereco  := Nil
    Self:cNome      := Nil
    Self:cSobreNome := Nil
    Self:nIdade     := Nil
    Self:lActive    := .F.
    
Return 