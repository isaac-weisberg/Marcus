func parse(tokens: [Token]) -> Expression {
    tokens.reduce([Context]()) { ctx, token in
        switch token {
        case .symbol(let symbol):
            switch symbol {
            case .roundBrackets(let openness):
                switch openness {
                case .open:
                    return ctx
                case .close:
                    return ctx
                }
            }
        case .label(let label):
            return ctx
        }
    }
    
    return Expression.label("FUCK")
}
