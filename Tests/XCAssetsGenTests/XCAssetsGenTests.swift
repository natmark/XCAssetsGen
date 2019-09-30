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
        do {
            try Generator.generate(url: URL(fileURLWithPath: "/Users/atsuya-sato/Desktop/github.com/XCAssetsGen/ColorAssets.xcassets"))
        } catch {

        }
    }
}
