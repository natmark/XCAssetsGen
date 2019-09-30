import Foundation
import Commandant
import XCAssetsGenKit

struct GenerateCommand: CommandProtocol {
    typealias Options = NoOptions<ClientError>
    typealias ClientError = XCAssetsGenKitError

    let verb = "generate"
    let function = "Generate code from .xcassets"

    func run(_ options: VersionCommand.Options) -> Result<(), VersionCommand.ClientError> {
        return .success(())
    }
}
