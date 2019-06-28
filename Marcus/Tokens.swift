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
    var tokens = [Token]()
    for char in string {
        switch char {
        case "{":
            tokens.append(.symbol(.curlyBrackets(.open)))
        case "}":
            tokens.append(.symbol(.curlyBrackets(.close)))
        case "(":
            tokens.append(.symbol(.roundBrackets(.open)))
        case ")":
            tokens.append(.symbol(.roundBrackets(.close)))
        case ":":
            tokens.append(.symbol(.colon))
        case " ":
            break
        default:
            if let latest = tokens.last {
                switch latest {
                case .label(let oldString):
                    _ = tokens.removeLast()
                    tokens.append(.label(oldString + String(char)))
                case .symbol:
                    tokens.append(.label(String(char)))
                }
            } else {
                tokens.append(.label(String(char)))
            }
        }
    }
    return tokens
}

enum TokenizeLabelResult {
    case success(Token.Label)
    case expectedLabel
}

func tokenizeLabel(iterator: inout FullIterator<Character>) -> TokenizeLabelResult {
    let nonLabelChars = "{}(): "
    var chars = [String.Element]()
    
    repeat {
        guard let next = iterator.next() else {
            break
        }
        if nonLabelChars.contains(next) {
            break
        }
        chars.append(next)
    } while true
    
    _ = iterator.prev()
    
    guard chars.count > 0 else {
        return .expectedLabel
    }
    return .success(Token.Label(chars))
}
