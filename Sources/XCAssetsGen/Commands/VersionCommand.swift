import Commandant
import XCAssetsGenKit

struct VersionCommand: CommandProtocol {
    typealias Options = NoOptions<ClientError>
    typealias ClientError = XCAssetsGenKitError

    let verb = "version"
    let function = "Display the current version of XCAssetsGen"

    func run(_ options: VersionCommand.Options) -> Result<(), VersionCommand.ClientError> {
        print(XCAssetsGenKitVersion.current.value)
        return .success(())
    }
}
