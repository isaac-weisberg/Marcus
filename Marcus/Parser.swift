enum FuncParserResult {
    enum Error {
        case invalidLabel(String)
        case expectedFunc(Token)
    }
    
    case empty
    case declared([Token])
    case error(Error)
}

func parseFunc(_ tokens: [Token]) -> FuncParserResult {
    guard let first = tokens.first else {
        return .empty
    }
    
    switch first {
    case .label(let label):
        switch label {
        case "func":
            return .declared(Array(tokens.dropFirst()))
        default:
            return .error(.invalidLabel(label))
        }
    case .symbol:
        return .error(.expectedFunc(first))
    }
}

enum FuncDeclarationResult {
    enum Error {
        case emptyDeclaration
        case expectedLabel(Token)
        case expectedParameterList
        case expectedSymbol(Token, Token.Symbol)
    }
    
    case error(Error)
}

func parseFuncDeclaration(declared tokens: [Token]) -> FuncDeclarationResult {
    guard let first = tokens.first else {
        return .error(.emptyDeclaration)
    }
    
    let functionName: String
    
    switch first {
    case .label(let label):
        functionName = label
    case .symbol:
        return .error(.expectedLabel(first))
    }
    
    guard let second = tokens.at(safe: 1) else {
        return .error(.expectedParameterList)
    }
    
    guard case .symbol(let symbol) = second, case .roundBrackets(let bracket) = symbol, case .open = bracket else {
        return .error(.expectedSymbol(second, .roundBrackets(.open)))
    }
    
    
}
