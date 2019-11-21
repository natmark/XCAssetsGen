import Yams
import Foundation

public struct Config: Decodable {
    public static let fileName = ".xcassetsgen.yml"

    public let image: Image?
    public let color: Color?

    enum CodingKeys: String, CodingKey {
        case image = "images"
        case color = "colors"
    }

    public struct Image: Decodable {
        public let inputs: [String]
        public let output: String
    }

    public struct Color: Decodable {
        public let inputs: [String]
        public let output: String
    }

    public init(string: String) throws {
        self = try YAMLDecoder().decode(from: string)
    }
    public init(url: URL) throws {
        self = try YAMLDecoder().decode(from: String(contentsOf: url))
    }
}


