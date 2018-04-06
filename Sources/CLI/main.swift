import Foundation
import Commander
import Harbor
import BrightFutures

let cli = Group {
  $0.command(
    "sign-in",
    Argument<String>("email", description: "Your Codeship e-mail"),
    Argument<String>("password", description: "Your Codeship password"),
    SignIn().call
  )

  $0.command(
    "projects",
    Projects().call
  )
}

cli.run()
