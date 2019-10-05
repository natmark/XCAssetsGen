import Foundation
import XCAssetsKit

struct ColorGenerator {
    struct ColorAsset {
        let name: String
        var path: [String] {
            return name.split(separator: "/").map { String($0) }
        }
        let colorSet: ColorSet
    }

    static func generate(xcassets: XCAssets) -> [String] {
        var outputLines = [String]()

        outputLines.append("extension UIColor {")
        var prefix: [String] = []
        var nests: [String] = []

        let colorAssets = Array(xcassets.assets.map { getColorAssets(asset: $0) }.joined())
                    .sorted(by: {
        $0.path.dropLast().joined(separator: "/") + "/" < $1.path.dropLast().joined(separator: "/") + "/"
                    })

        for colorAsset in colorAssets {
            if colorAsset.path.subtracting(prefix).count == 1 {
                outputLines.append(getTabString(nestCount: prefix.count + 1) + "public \(colorAsset.path.count > 1 ? "var": "static var") \(colorAsset.colorSet.fileName.lowerCamelCased()): UIColor {")
                outputLines.append(getTabString(nestCount: prefix.count + 1) + "\t" + "return ColorProvider.color(named: \"\(colorAsset.name)\")!")
                outputLines.append(getTabString(nestCount: prefix.count + 1) + "}")
            } else {
                for i in 0..<prefix.subtracting(colorAsset.path.dropLast()).count {
                    let tab = [String](repeating: "\t", count: prefix.count + 1 - (i + 1)).joined()
                    outputLines.append(tab + "}")
                }
                nests = colorAsset.path.subtracting(prefix).dropLast()
                prefix = colorAsset.path.dropLast()

                for (index, nest) in nests.enumerated() {
                    outputLines.append(getTabString(nestCount: prefix.count - nests.count + 1 + index) + "public \(prefix.count - nests.count > 0 ? "var": "static var") \(nest.lowerCamelCased()): \(nest.upperCamelCased()) {")
                    outputLines.append(getTabString(nestCount: prefix.count - nests.count + 1 + index) + "\t" + "return \(nest.upperCamelCased())()")
                    outputLines.append(getTabString(nestCount: prefix.count - nests.count + 1 + index) + "}")
                    outputLines.append(getTabString(nestCount: prefix.count - nests.count + 1 + index) + "public struct \(nest.upperCamelCased()) {")
                }

                outputLines.append(getTabString(nestCount: prefix.count + 1) + "public \(colorAsset.path.count > 1 ? "var": "static var") \(colorAsset.colorSet.fileName.lowerCamelCased()): UIColor {")
                outputLines.append(getTabString(nestCount: prefix.count + 1) + "\t" + "return ColorProvider.color(named: \"\(colorAsset.name)\")!")
                outputLines.append(getTabString(nestCount: prefix.count + 1) + "}")
            }
        }

        for i in 0..<prefix.count + 1 {
            outputLines.append(getTabString(nestCount: prefix.count - i) + "}")
        }

        return outputLines
    }

    private static func getColorAssets(prefix: String = "", asset: Asset) -> [ColorAsset] {
        if case .colorSet(let colorSet) = asset {
            return [ColorAsset(name: "\(prefix)\(colorSet.fileName)", colorSet: colorSet)]
        }

        if case .folder(let folder) = asset {
            if folder.contents.properties?.providesNamespace ?? false {
                return Array(folder.assets.map { getColorAssets(prefix: prefix + folder.fileName + "/", asset: $0) }.joined())
            } else {
                return Array(folder.assets.map { getColorAssets(prefix: prefix, asset: $0) }.joined())
            }
        }

        if asset.assetType.acceptedChildAssetTypes.contains(.colorSet) {
            return Array(asset.assets.map { getColorAssets(prefix: prefix, asset: $0) }.joined())
        }

        return []
    }
}
