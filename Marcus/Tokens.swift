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

let tokenMap: [Character: Token.Symbol] = [
    "{" : .curlyBrackets(.open),
    "}" : .curlyBrackets(.close),
    "(" : .roundBrackets(.open),
    ")" : .roundBrackets(.close),
    ":" : .colon
]

func tokenize(_ string: String) -> [Token] {
    enum ContigiousCtx {
        case empty
        case label([Token.Label.Element])
    }
    var ctx = ContigiousCtx.empty
    
    return string.reduce([Token]()) { res, char in
        switch char {
        case "{":
            ctx = .empty
            return res + [.symbol(.curlyBrackets(.open))]
        case "}":
            ctx = .empty
            return res + [.symbol(.curlyBrackets(.close))]
        case "(":
            ctx = .empty
            return res + [.symbol(.roundBrackets(.open))]
        case ")":
            ctx = .empty
            return res + [.symbol(.roundBrackets(.close))]
        case ":":
            ctx = .empty
            return res + [.symbol(.colon)]
        case " ":
            ctx = .empty
            return res
        default:
            switch ctx {
            case .empty:
                ctx = .label([char])
                return res
            case .label(let chars):
                ctx = .label(chars + [char])
                return res
            }
        }
    }
}
