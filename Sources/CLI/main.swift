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
    ListProjects().call
  )

  $0.command(
    "builds",
    Argument<Int>("project-index", description: "The index of the project to list builds for"),
    ListBuilds().call
  )
}

cli.run()
