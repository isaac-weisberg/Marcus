enum Token {
    enum Opennes {
        case open
        case close
    }
    
    case whitespace
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
    ":" : .colon,
    " " : .whitespace
]

func tokenize(_ string: String) -> [Token] {
    var tokens = [Token]()
    for char in string {
        if let ezToken = tokenMap[char] {
            tokens.append(ezToken)
        } else if let latest = tokens.last {
            switch latest {
            case .label(let oldString):
                _ = tokens.removeLast()
                tokens.append(.label(oldString + String(char)))
            case .colon, .curlyBrackets, .roundBrackets, .whitespace:
                tokens.append(.label(String(char)))
            }
        } else {
            tokens.append(.label(String(char)))
        }
    }
    return tokens
}
