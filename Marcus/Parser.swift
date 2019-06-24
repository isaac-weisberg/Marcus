enum FuncParserResult {
    enum Error {
        case invalidLabel(String)
        case unexpectedToken(Token)
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
    case .colon, .curlyBrackets, .roundBrackets:
        return .error(.unexpectedToken(first))
    }
}
