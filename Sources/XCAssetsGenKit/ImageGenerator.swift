import Foundation
import XCAssetsKit

struct ImageGenerator {
    struct ImageAsset {
        let name: String
        var path: [String] {
            return name.split(separator: "/").map { String($0) }
        }
        let imageSet: ImageSet
    }

    static func generate(xcassets: XCAssets) -> [String] {
        var outputLines = [String]()

        outputLines.append("extension UIImage {")
        var prefix: [String] = []
        var nests: [String] = []

        let imageAssets = Array(xcassets.assets.map { getImageAssets(asset: $0) }.joined())
                    .sorted(by: {
        $0.path.dropLast().joined(separator: "/") + "/" < $1.path.dropLast().joined(separator: "/") + "/"
                    })

        for imageAsset in imageAssets {
            if imageAsset.path.subtracting(prefix).count == 1 {
                outputLines.append(getTabString(nestCount: prefix.count + 1) + "public \(imageAsset.path.count > 1 ? "var": "static var") \(imageAsset.imageSet.fileName.lowerCamelCased()): UIImage {")
                outputLines.append(getTabString(nestCount: prefix.count + 1) + "\t" + "return ImageProvider.image(named: \"\(imageAsset.name)\")!")
                outputLines.append(getTabString(nestCount: prefix.count + 1) + "}")
            } else {
                for i in 0..<prefix.subtracting(imageAsset.path.dropLast()).count {
                    let tab = [String](repeating: "\t", count: prefix.count + 1 - (i + 1)).joined()
                    outputLines.append(tab + "}")
                }
                nests = imageAsset.path.subtracting(prefix).dropLast()
                prefix = imageAsset.path.dropLast()

                for (index, nest) in nests.enumerated() {
                    outputLines.append(getTabString(nestCount: prefix.count - nests.count + 1 + index) + "public \(prefix.count - nests.count > 0 ? "var": "static var") \(nest.lowerCamelCased()): \(nest.upperCamelCased()) {")
                    outputLines.append(getTabString(nestCount: prefix.count - nests.count + 1 + index) + "\t" + "return \(nest.upperCamelCased())()")
                    outputLines.append(getTabString(nestCount: prefix.count - nests.count + 1 + index) + "}")
                    outputLines.append(getTabString(nestCount: prefix.count - nests.count + 1 + index) + "public struct \(nest.upperCamelCased()) {")
                }

                outputLines.append(getTabString(nestCount: prefix.count + 1) + "public \(imageAsset.path.count > 1 ? "var": "static var") \(imageAsset.imageSet.fileName.lowerCamelCased()): UIImage {")
                outputLines.append(getTabString(nestCount: prefix.count + 1) + "\t" + "return ImageProvider.image(named: \"\(imageAsset.name)\")!")
                outputLines.append(getTabString(nestCount: prefix.count + 1) + "}")
            }
        }

        for i in 0..<prefix.count + 1 {
            outputLines.append(getTabString(nestCount: prefix.count - i) + "}")
        }

        return outputLines
    }

    private static func getImageAssets(prefix: String = "", asset: Asset) -> [ImageAsset] {
        if case .imageSet(let imageSet) = asset {
            return [ImageAsset(name: "\(prefix)\(imageSet.fileName)", imageSet: imageSet)]
        }

        if case .folder(let folder) = asset {
            if folder.contents.properties?.providesNamespace ?? false {
                return Array(folder.assets.map { getImageAssets(prefix: prefix + folder.fileName + "/", asset: $0) }.joined())
            } else {
                return Array(folder.assets.map { getImageAssets(prefix: prefix, asset: $0) }.joined())
            }
        }

        if asset.assetType.acceptedChildAssetTypes.contains(.imageSet) {
            return Array(asset.assets.map { getImageAssets(prefix: prefix, asset: $0) }.joined())
        }

        return []
    }
}
