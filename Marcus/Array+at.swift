extension Array {
    func at(safe index: Index) -> Element? {
        guard (0..<count).contains(index) else {
            return nil
        }
        return self[index]
    }
}
