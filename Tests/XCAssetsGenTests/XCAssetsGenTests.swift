//
//  XCAssetsGenTests.swift
//  Commandant
//
//  Created by atsuya-sato on 2019/08/12.
//

import XCTest
import XCAssetsGenKit

class XCAssetsGenTests: XCTestCase {
    func testGenerate() {
        print(FileManager.default.currentDirectoryPath)
                let configString =
        """
        images:
          inputs:
            - Tests/Resources/ImageAssets.xcassets
          output: Tests/UIImage+XCAssetsGen.swift
        colors:
          inputs:
            - Tests/Resources/ColorAssets.xcassets
          output: Tests/UIColor+XCAssetsGen.swift
        """

        let config = try! Config(string: configString)
        // $(PROJECT_ROOT)/Tests/XCAssetsGenTests/XCAssetsGenTests
        let projectRoot = URL(fileURLWithPath: #file).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
        try! Generator.generate(url: projectRoot, config: config)

        XCTAssertTrue(projectRoot.appendingPathComponent(config.color!.output).isExist)
        XCTAssertTrue(projectRoot.appendingPathComponent(config.image!.output).isExist)

        try! FileManager.default.removeItem(at: projectRoot.appendingPathComponent(config.color!.output))
        try! FileManager.default.removeItem(at: projectRoot.appendingPathComponent(config.image!.output))
    }

    func testConfig() {
        let configString =
"""
images:
  inputs:
    - ImageAssets.xcassets
    - ImageAssets2.xcassets
  output: UIImage+XCAssetsGen.swift
colors:
  inputs:
    - ColorAssets.xcassets
  output: UIColor+XCAssetsGen.swift
"""
        let config = try? Config(string: configString)
        XCTAssertNotNil(config?.image)
        XCTAssertNotNil(config?.color)
        XCTAssertEqual(config?.image?.inputs, ["ImageAssets.xcassets", "ImageAssets2.xcassets"])
        XCTAssertEqual(config?.color?.inputs, ["ColorAssets.xcassets"])
        XCTAssertEqual(config?.image?.output, "UIImage+XCAssetsGen.swift")
        XCTAssertEqual(config?.color?.output, "UIColor+XCAssetsGen.swift")
    }
}
