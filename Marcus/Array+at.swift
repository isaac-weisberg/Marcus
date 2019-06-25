extension Array {
    func at(safe index: Index) -> Element? {
        guard self.count > index else {
            return nil
        }
        return self[index]
    }
}
