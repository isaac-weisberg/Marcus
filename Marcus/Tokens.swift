enum Token {
    enum Opennes {
        case open
        case close
    }
    
    case colon
    case roundBrackets(Opennes)
    case curlyBrackets(Opennes)
    case label(String)
}

let tokenMap: [Character: Token] = [
    "{" : .curlyBrackets(.open),
    "}" : .curlyBrackets(.close),
    "(" : .roundBrackets(.open),
    ")" : .roundBrackets(.close),
    ":" : .colon
]

func tokenize(_ string: String) {
    var tokens = [Token]()
    for char in string {
        if let ezToken = tokenMap[char] {
            tokens.append(ezToken)
        } else if let latest = tokens.last {
            switch latest {
            case .label(let oldString):
                tokens.append(.label(oldString + String(char)))
            case .colon, .curlyBrackets, .roundBrackets:
                tokens.append(.label(String(char)))
            }
        } else {
            tokens.append(.label(String(char)))
        }
    }
    
}
