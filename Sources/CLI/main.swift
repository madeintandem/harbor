import Foundation
import Commander
import Harbor
import BrightFutures

let cli = Group {
  $0.command(
    "sign-in",
    Argument<String>("email", description: "Your Codeship e-mail"),
    Argument<String>("password", description: "Your Codeship password"),
    description: "Signs in with your Codeship credentials.",
    SignIn().call
  )

  $0.command(
    "projects",
    description: "Lists all projects in all organizations for the signed-in user.",
    ListProjects().call
  )

  $0.command(
    "builds",
    Option<ListBuilds.Path?>(
      "path",
      default: nil,
      flag: "p",
      description: "The <org-key><project-key> path to the project (e.g. `0a`), which can be found by running the `projects` command."
    ),
    description: "Lists the most recent builds for a given project.",
    ListBuilds().call
  )
}

cli.run()
