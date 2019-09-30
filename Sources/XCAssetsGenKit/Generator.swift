import Foundation
import XCAssetsKit

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

public struct ColorAsset {
    let name: String
    var path: [String] {
        return name.split(separator: "/").map { String($0) }
    }
    let colorSet: ColorSet
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

public struct Generator {
    private static func getTabString(nestCount: Int) -> String {
        return [String](repeating: "\t", count: nestCount).joined()
    }

    private static func createColorExtension(tab: String, colorAsset: ColorAsset) -> [String] {
        var lines = [String]()
        lines.append(tab + "public \(colorAsset.path.count > 1 ? "var": "static var") \(colorAsset.colorSet.fileName.lowerCamelCased()): UIColor {")
        lines.append(tab + "\t" + "return ColorProvider.color(named: \"\(colorAsset.name)\")!")
        lines.append(tab + "}")
        return lines
    }

    public static func generate(url: URL) throws {
        let xcassets = try XCAssets(fileURL: url)
        var outputLines = [String]()
        let colorAssets = Array(xcassets.assets.map { getColorAssets(asset: $0) }.joined())
            .sorted(by: {
$0.path.dropLast().joined(separator: "/") + "/" < $1.path.dropLast().joined(separator: "/") + "/"
            })
        outputLines.append("// Generated by XCAssetsGen - \(XCAssetsGenKitVersion.current)")
        outputLines.append("")
        outputLines.append("import UIKit")
        outputLines.append("class ColorProvider {")
        outputLines.append("\t" + "static func color(named name: String) -> UIColor? {")
        outputLines.append("\t" + "\t" + "let bundle = Bundle(for: ColorProvider.self)")
        outputLines.append("\t" + "\t" + "return UIColor(named: name, in: bundle, compatibleWith: nil)")
        outputLines.append("\t" + "}")
        outputLines.append("}")

        outputLines.append("extension UIColor {")

        var prefix: [String] = []
        var nests: [String] = []

        for colorAsset in colorAssets {
            if colorAsset.path.subtracting(prefix).count == 1 {
                print("fileName: ", colorAsset.name)
                outputLines += createColorExtension(tab: getTabString(nestCount: prefix.count + 1), colorAsset: colorAsset)
            } else {
                for i in 0..<prefix.subtracting(colorAsset.path.dropLast()).count {
                    let tab = [String](repeating: "\t", count: prefix.count + 1 - (i + 1)).joined()
                    outputLines.append(tab + "}")
                }
                nests = colorAsset.path.subtracting(prefix).dropLast()
                print("nests", nests)
                prefix = colorAsset.path.dropLast()
                print("prefix", prefix)

                for (index, nest) in nests.enumerated() {
                    outputLines.append(getTabString(nestCount: prefix.count - nests.count + 1 + index) + "public \(prefix.count - nests.count > 0 ? "var": "static var") \(nest.lowerCamelCased()): \(nest.upperCamelCased()) {")
                    outputLines.append(getTabString(nestCount: prefix.count - nests.count + 1 + index) + "\t" + "return \(nest.upperCamelCased())()")
                    outputLines.append(getTabString(nestCount: prefix.count - nests.count + 1 + index) + "}")
                    outputLines.append(getTabString(nestCount: prefix.count - nests.count + 1 + index) + "public struct \(nest.upperCamelCased()) {")
                }

                outputLines += createColorExtension(tab: getTabString(nestCount: prefix.count + 1), colorAsset: colorAsset)
            }
        }

        for i in 0..<prefix.count + 1 {
            outputLines.append(getTabString(nestCount: prefix.count - i) + "}")
        }

        print(outputLines.joined(separator: "\n"))
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
