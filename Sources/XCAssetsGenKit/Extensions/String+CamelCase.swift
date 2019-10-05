extension String {
    func upperCamelCased() -> String {
        return self.components(separatedBy: .punctuationCharacters)
            .map { String($0) }
            .enumerated()
            .map { $0.offset >= 0 ? $0.element.capitalized : $0.element.lowercased() }
            .joined()
    }

    func lowerCamelCased() -> String {
        return self.components(separatedBy: .punctuationCharacters)
            .map { String($0) }
            .enumerated()
            .map { $0.offset > 0 ? $0.element.capitalized : $0.element.lowercased() }
            .joined()
    }
}
