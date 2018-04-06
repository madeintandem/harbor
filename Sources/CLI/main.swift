import Foundation
import Commander
import Harbor
import BrightFutures

let cli = Group {
  $0.command(
    "sign-in",
    Argument<String>("email", description: "Your Codeship e-mail"),
    Argument<String>("password", description: "Your Codeship password")
  ) { email, password in
    User.SignIn()
      .call(
        email: email,
        password: password
      )
      .onSuccess { user in
        print("signed in!")
      }
      .onFailure { error in
        print("failed to sign in: \(error)")
      }

    CFRunLoopRun()
  }

  $0.command(
    "projects"
  ) {
    let operation = AnyFuture.serially(
      User.SignInCurrent()
        .call()
        .anytyped(),
      User.ListProjects()
        .call()
        .onSuccess { projects in
          print("projects: \(projects)")
        }
        .anytyped()
    )

    operation.onFailure { error in
      print("failed to list projects: \(error)")
    }

    CFRunLoopRun()
  }
}

cli.run()
