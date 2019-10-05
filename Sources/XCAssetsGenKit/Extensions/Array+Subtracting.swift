extension Array where Element: Equatable {
    typealias E = Element

    func subtracting(_ other: [E]) -> [E] {
        return self.compactMap { element in
            if (other.filter { $0 == element }).count == 0 {
                return element
            } else {
                return nil
            }
        }
    }

    mutating func subtract(_ other: [E]) {
        self = subtracting(other)
    }
}

typealias SortDescriptor<Value> = (Value, Value) -> Bool
func combine<Value>(sortDescriptors: [SortDescriptor<Value>]) -> SortDescriptor<Value> {
    return { lhs, rhs in
        for isOrderedBefore in sortDescriptors {
            if isOrderedBefore(lhs,rhs) { return true }
            if isOrderedBefore(rhs,lhs) { return false }
        }
        return false
    }
}
