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
            - ImageAssets.xcassets
          output: UIImage+XCAssetsGen.swift
        colors:
          inputs:
            - ColorAssets.xcassets
          output: UIColor+XCAssetsGen.swift
        """

        do {
            let config = try Config(string: configString)
            try Generator.generate(url: URL(fileURLWithPath: "/Users/atsuya-sato/Desktop/github.com/XCAssetsGen/"), config: config)
        } catch {

        }
    }

    func testConfig() {
        let configString =
"""
images:
  inputs:
    - ImageAssets.xcassets
  output: UIImage+XCAssetsGen.swift
colors:
  inputs:
    - ColorAssets.xcassets
  output: UIColor+XCAssetsGen.swift
"""
        do {
            let config = try Config(string: configString)
            print(config)
        } catch {

        }
    }
}
