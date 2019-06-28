enum Token {
    typealias Label = String
    
    enum Symbol {
        enum Opennes {
            case open
            case close
        }
        
        case colon
        case roundBrackets(Opennes)
        case curlyBrackets(Opennes)
    }
    
    case symbol(Symbol)
    case label(Label)
}

func tokenize(_ string: String) -> [Token] {
    enum ContigiousCtx {
        case empty
        case label([Token.Label.Element])
    }
    
    return string.reduce(([Token](), ContigiousCtx.empty)) { stuff, char in
        let (res, ctx) = stuff
        switch char {
        case "{":
            return (res + [.symbol(.curlyBrackets(.open))], .empty)
        case "}":
            return (res + [.symbol(.curlyBrackets(.close))], .empty)
        case "(":
            return (res + [.symbol(.roundBrackets(.open))], .empty)
        case ")":
            return (res + [.symbol(.roundBrackets(.close))], .empty)
        case ":":
            return (res + [.symbol(.colon)], .empty)
        case " ":
            return (res, .empty)
        default:
            switch ctx {
            case .empty:
                return (res, .label([char]))
            case .label(let chars):
                return (res, .label(chars + [char]))
            }
        }
    }.0
}
