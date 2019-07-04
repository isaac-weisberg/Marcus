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

enum FuncDeclarationParserResult {
    enum Error {
        case emptyDeclaration
        case expectedLabel(Token)
        case expectedParameterList
        case incompleteParameterList
        case expectedSymbol(Token, Token.Symbol)
        case unexpectedSymbol(Token)
    }
    
    case error(Error)
}

func parseFuncDeclaration(declared tokens: inout IndexingIterator<[Token]>) -> FuncDeclarationParserResult {
    guard let first = tokens.next() else {
        return .error(.emptyDeclaration)
    }
    
    let functionName: String
    
    switch first {
    case .label(let label):
        functionName = label
    case .symbol:
        return .error(.expectedLabel(first))
    }
    
    guard let second = tokens.next() else {
        return .error(.expectedParameterList)
    }
    
    guard case .symbol(let symbol) = second, case .roundBrackets(let bracket) = symbol, case .open = bracket else {
        return .error(.expectedSymbol(second, .roundBrackets(.open)))
    }

    struct ParsedParameter {
        let name: String
        let type: String
    }
    
    enum ParameterContext {
        case empty
        case name(String)
        case colon(name: String)
    }
    
    var context = ParameterContext.empty
    var parameters = [ParsedParameter]()
    
    parameterLoop: repeat {
        guard let token = tokens.next() else {
            return .error(.incompleteParameterList)
        }
        
        switch token {
        case .label(let label):
            switch context {
            case .empty:
                context = .name(label)
            case .name:
                return .error(.expectedSymbol(token, .colon))
            case .colon(let name):
                parameters.append(ParsedParameter(name: name, type: label))
                context = .empty
            }
        case .symbol(let symbol):
            switch symbol {
            case .colon:
                switch context {
                case .empty:
                    return .error(.expectedLabel(token))
                case .name(let name):
                    context = .colon(name: name)
                case .colon:
                    return .error(.expectedLabel(token))
                }
            case .curlyBrackets:
                return .error(.unexpectedSymbol(token))
            case .roundBrackets(let openness):
                switch openness {
                case .open:
                    return .error(.unexpectedSymbol(token))
                case .close:
                    switch context {
                    case .empty:
                        break parameterLoop
                    case .name:
                        return .error(.expectedSymbol(token, .colon))
                    case .colon:
                        return .error(.expectedLabel(token))
                    }
                }
            }
            
            
        }
    } while true
}


enum ParseFuncFuncRes {
    enum Error {
        enum NameParsing {
            case expectedLabel(Token)
        }
        
        case nameDeclaration(NameParsing)
    }
    
    enum State {
        case named(String)
        case idle
    }
    
    case good(State)
    case erroneous(Error, State)
}

func parseFuncFunc(tokens: [Token]) -> ParseFuncFuncRes {
    tokens.reduce(ParseFuncFuncRes.good(.idle)) { ctx, token in
        switch ctx {
        case .erroneous:
            return ctx
        case .good(let state):
            switch state {
            case .idle:
                switch token {
                case .label(let label):
                    return .good(.named(label))
                case .symbol:
                    return .erroneous(.nameDeclaration(.expectedLabel(token)), state)
                }
            }
        }
    }
}
