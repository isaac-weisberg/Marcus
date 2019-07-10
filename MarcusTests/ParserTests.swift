import XCTest
@testable import Marcus

class ParserTests: XCTestCase {
    struct Data {
        let tokens: [Token]
        let exp: Expression
        let file: StaticString
        let line: UInt
        
        init(_ tokens: [Token], _ exp: Expression, file: StaticString = #file, line: UInt = #line) {
            self.tokens = tokens
            self.exp = exp
            self.file = file
            self.line = line
        }
    }
    
    func validate(data: Data) {
        let parsed = parse(tokens: data.tokens)
        XCTAssertEqual(parsed, data.exp, "\nGot \n\n\(parsed)\n\nexpected\n\n\(data.exp)", file: data.file, line: data.line)
    }
    
    func testParsing() {
        let data: [Data] = [
            Data([], .seq([])),
        ]
        
        data
            .forEach { (data: Data) in
                validate(data: data)
            }
    }
}
