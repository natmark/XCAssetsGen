import Foundation
import Commandant
import XCAssetsGenKit

let registry = CommandRegistry<XCAssetsGenKitError>()
registry.register(VersionCommand())
registry.register(GenerateCommand())

let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)

registry.main(defaultVerb: helpCommand.verb) { error in
    fputs(error.localizedDescription + "\n", stderr)
}
