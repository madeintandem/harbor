import Foundation
import Harbor

struct Projects {
  func call() {
    Ui.loading()

    let operation = AnyFuture.serially(
      User.SignInCurrent()
        .call()
        .anytyped(),
      User.ListProjects()
        .call()
        .onSuccess(callback: render)
        .anytyped()
    )

    operation.onFailure { error in
      Ui.error("failed to list projects: \(error)")
    }

    CFRunLoopRun()
  }

  // MARK: rendering
  private func render(projects: [Project]) {
    for project in projects {
      Ui.info("\(project)")
    }
  }
}
