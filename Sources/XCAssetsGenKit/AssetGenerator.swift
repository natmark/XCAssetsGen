import Foundation
import XCAssetsKit

struct AssetGenerator {
    struct AssetInfo {
        let name: String
        var path: [String] {
            return name.split(separator: "/").map { String($0) }
        }
        let fileName: String
    }

    static func generate(xcassets: XCAssets, assetType: AssetSource.AssetType) -> [String] {
        var outputLines = [String]()

        outputLines.append("extension \(assetType.uiKitClassName) {")

        // Sort by ascending order of hierarchy and group by folder
        let assets = Array(xcassets.assets.map { getAssetInfo(asset: $0, assetType: assetType) }.joined())
                    .sorted(by: {
        $0.path.dropLast().joined(separator: "/") + "/" < $1.path.dropLast().joined(separator: "/") + "/"
                    })

        for (index, asset) in assets.enumerated() {
            let previousAssets: AssetInfo? = index > 0 ? assets[index - 1] : nil
            let nextAssets: AssetInfo? = index + 1 < assets.count ? assets[index + 1] : nil

            let nests = removeMatchingFirst(source: asset.path.dropLast(), target: previousAssets?.path.dropLast() ?? [])

            // namespace definition
            for (index, nest) in nests.enumerated() {
                let nameSpaceTabs = Array(repeating: "\t", count: getMatchingFirst(source: asset.path.dropLast(), target: previousAssets?.path.dropLast() ?? []).count + index + 1).joined()
                let isStaticVar = getMatchingFirst(source: asset.path.dropLast(), target: previousAssets?.path.dropLast() ?? []).count == 0 && index == 0
                outputLines.append(nameSpaceTabs + "public \(isStaticVar ? "static var": "var") \(nest.lowerCamelCased()): \(nest.upperCamelCased()) {")
                outputLines.append(nameSpaceTabs + "\t" + "return \(nest.upperCamelCased())()")
                outputLines.append(nameSpaceTabs + "}")
                outputLines.append(nameSpaceTabs + "public struct \(nest.upperCamelCased()) {")
            }

            // color definition
            let elementTabs = Array(repeating: "\t", count: asset.path.dropLast().count + 1).joined()

            outputLines.append(elementTabs + "public \(asset.path.count > 0 ? "var": "static var") \(asset.fileName.lowerCamelCased()): \(assetType.uiKitClassName) {")
            outputLines.append(elementTabs + "\t" + "return ResourceProvider.\(assetType.rawValue)(named: \"\(asset.name)\")!")
            outputLines.append(elementTabs + "}")

            // close namespace scope
            let nestSize = asset.path.dropLast().count - getMatchingFirst(source: nextAssets?.path.dropLast() ?? [], target: asset.path.dropLast()).count
            for index in 0..<nestSize {
                let rightBraceTabs = Array(repeating: "\t", count: asset.path.dropLast().count - index).joined()
                outputLines.append(rightBraceTabs + "}")
            }
        }

        outputLines.append("}")
        return outputLines
    }

    private static func getMatchingFirst(source: [String], target: [String]) -> [String] {
        var nests = [String]()
        let maxMatchSize = min(source.count, target.count)
        for index in 0..<maxMatchSize {
            if source[index] == target[index] {
                nests.append(source[index])
            } else {
                return nests
            }
        }
        return nests
    }

    private static func removeMatchingFirst(source: [String], target: [String]) -> [String] {
        var nests = source
        let maxMatchSize = min(source.count, target.count)
        for index in 0..<maxMatchSize {
            if source[index] == target[index] {
                nests.removeFirst()
            } else {
                return nests
            }
        }
        return nests
    }

    private static func getAssetInfo(prefix: String = "", asset: Asset, assetType: AssetSource.AssetType) -> [AssetInfo] {
        if case .color = assetType, case .colorSet(let colorSet) = asset {
            return [AssetInfo(name: "\(prefix)\(colorSet.fileName)", fileName: colorSet.fileName)]
        }
        if case .image = assetType, case .imageSet(let imageSet) = asset {
            return [AssetInfo(name: "\(prefix)\(imageSet.fileName)", fileName: imageSet.fileName)]
        }

        if case .folder(let folder) = asset {
            if folder.contents.properties?.providesNamespace ?? false {
                return Array(folder.assets.map { getAssetInfo(prefix: prefix + folder.fileName + "/", asset: $0, assetType: assetType) }.joined())
            } else {
                return Array(folder.assets.map { getAssetInfo(prefix: prefix, asset: $0, assetType: assetType) }.joined())
            }
        }

        if asset.assetType.acceptedChildAssetTypes.contains(.colorSet) {
            return Array(asset.assets.map { getAssetInfo(prefix: prefix, asset: $0, assetType: assetType) }.joined())
        }

        return []
    }
}
