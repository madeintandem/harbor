import Foundation
import Commander
import Harbor

let main = Group {
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
      .onSuccess { _ in
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
    User.ListProjects()
      .call()
      .onSuccess { projects in
        print("projects: \(projects)")
      }
      .onFailure { error in
        print("failued to list projects: \(error)")
      }

    CFRunLoopRun()
  }
}

main.run()
