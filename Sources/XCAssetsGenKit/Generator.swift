import Foundation
import XCAssetsKit

func getTabString(nestCount: Int) -> String {
    return [String](repeating: "\t", count: nestCount).joined()
}

public struct Generator {
    public static func generate(url: URL, config: Config) throws {
        let assetSources = convertToAssetSource(from: config).sorted(by: { $0.output < $1.output })

        var outputLines = [String]()

        for (index, assetSource) in assetSources.enumerated() {
            if index == 0 || assetSources[index - 1].output != assetSource.output {
                outputLines += createHeaderLine()
            }

            for input in assetSource.inputs {
                print("▶︎ \(assetSource.assetType.rawValue)Asset: \(input)")
                let xcassets = try XCAssets(fileURL: url.appendingPathComponent(input))
                outputLines += AssetGenerator.generate(xcassets: xcassets, assetType: assetSource.assetType)
            }

            if index == (assetSources.count - 1) || assetSource.output != assetSources[index + 1].output {
                try outputLines.joined(separator: "\n").write(to: url.appendingPathComponent(assetSource.output), atomically: true, encoding: .utf8)
                outputLines.removeAll()
                print("⚙ Generating: \(url.appendingPathComponent(assetSource.output).absoluteString)")
            }
        }
    }

    private static func createHeaderLine() -> [String] {
        var outputLines = [String]()

        outputLines.append("// Generated by XCAssetsGen - \(XCAssetsGenKitVersion.current)")
        outputLines.append("")
        outputLines.append("import UIKit")

        outputLines.append("fileprivate class ResourceProvider {")
        for assetType in AssetSource.AssetType.allCases {
            outputLines.append("\t" + "static func \(assetType.rawValue)(named name: String) -> \(assetType.uiKitClassName)? {")
            outputLines.append("\t" + "\t" + "let bundle = Bundle(for: ResourceProvider.self)")
            outputLines.append("\t" + "\t" + "return \(assetType.uiKitClassName)(named: name, in: bundle, compatibleWith: nil)")
            outputLines.append("\t" + "}")
        }
        outputLines.append("}")
        outputLines.append("")

        return outputLines
    }

    private static func convertToAssetSource(from config: Config) -> [AssetSource] {
        var assetSources = [AssetSource]()
        if let color = config.color {
            assetSources.append(AssetSource(inputs: color.inputs, output: color.output, assetType: .color))
        }
        if let image = config.image {
            assetSources.append(AssetSource(inputs: image.inputs, output: image.output, assetType: .image))
        }
        return assetSources
    }
}
