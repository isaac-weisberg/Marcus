func parse(tokens: [Token]) -> Expression {
    enum Node {
        case label(String)
        case node([Node])
    }
    
    tokens.reduce([Node]()) { ctx, token in
        switch token {
        case .symbol(let symbol):
            switch symbol {
            case .roundBrackets(let openness):
                switch openness {
                case .open:
                    let newNode = Node.node([])
                    return ctx + [ newNode ]
                case .close:
                    
                }
            }
        case .label(let label):
            guard let last = ctx.last else {
                let newNode = Node.node([ .label(label) ])
                return ctx + [ newNode ]
            }
            
        }
    }
    
    return Expression.label("FUCK")
}
