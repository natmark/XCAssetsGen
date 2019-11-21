struct AssetSource {
    let inputs: [String]
    let output: String
    let assetType: AssetType

    enum AssetType: String, CaseIterable {
        case image
        case color
    }
}


extension AssetSource.AssetType {
    var uiKitClassName: String {
        switch self {
        case .image:
            return "UIImage"
        case .color:
            return "UIColor"
        }
    }
}
