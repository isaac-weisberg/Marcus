

struct FunctionDeclaration {
    struct Parameter {
        let outerLabel: String
        let innerLabel: String
        let type: TypeDeclaration
    }
    
    enum Exception {
        case none
        case some(ErrorTypeDeclaration)
    }
    
    let label: String
    let parameters: [Parameter]
    let returnType: TypeDeclaration
    let exceptionType: Exception
}
