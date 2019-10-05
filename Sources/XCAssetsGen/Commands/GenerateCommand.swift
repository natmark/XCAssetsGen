import Foundation
import Commandant
import Curry
import XCAssetsGenKit

struct GenerateCommand: CommandProtocol {
    typealias Options = GenerateOptions
    typealias ClientError = Options.ClientError

    let verb = "generate"
    let function = "Generate code from .xcassets"

    func run(_ options: GenerateCommand.Options) -> Result<(), GenerateCommand.ClientError> {
        do {
            let config = try Config(url: URL(fileURLWithPath: options.configPath))
            try Generator.generate(url: URL(fileURLWithPath: options.path), config: config)
        } catch let error {
            return .failure(.unknown(message: error.localizedDescription))
        }
        return .success(())
    }
}

struct GenerateOptions: OptionsProtocol {
    typealias ClientError = XCAssetsGenKitError
    let path: String
    let configPath: String

    static func evaluate(_ m: CommandMode) -> Result<GenerateOptions, CommandantError<GenerateOptions.ClientError>> {
        return curry(self.init)
            <*> m <| Option(key: "path", defaultValue: FileManager.default.currentDirectoryPath, usage: "generate project root directory")
            <*> m <| Option(key: "configPath", defaultValue: FileManager.default.currentDirectoryPath + "/" + Config.fileName, usage: "path to .xcassetsgen.yml")
    }
}
