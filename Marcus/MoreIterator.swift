protocol MoreIterator: IteratorProtocol {
    mutating func prev() -> Element?
    
    func peek() -> Element?
}

struct FullIterator<Element>: MoreIterator {
    typealias Collection = [Element]
    
    var index: Collection.Index = -1
    let collection: Collection
    
    init(_ collection: Collection) {
        self.collection = collection
    }
    
    mutating func next() -> Element? {
        guard index != collection.count else {
            return nil
        }
        index += 1
        return collection.at(safe: index)
    }
    
    mutating func prev() -> Element? {
        guard index != -1 else {
            return nil
        }
        index -= 1
        return collection.at(safe: index)
    }
    
    func peek() -> Element? {
        return collection.at(safe: index + 1)
    }
}

extension String {
    func fullIterator() -> FullIterator<Element> {
        return FullIterator(Array(self))
    }
}
