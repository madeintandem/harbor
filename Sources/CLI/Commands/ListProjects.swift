import Foundation
import Harbor

struct ListProjects {
  func call() {
    Ui.Loading.start()

    let operation = AnyFuture.serially(
      User.SignInCurrent()
        .call()
        .anytyped(),
      User.ListProjects()
        .call()
        .onSuccess(callback: render)
        .anytyped()
    )

    operation
      .onFailure { error in
        Ui.error("failed to list projects: \(error)")
      }
      .onComplete { _ in
        Ui.Loading.stop()
        CFRunLoopStop(CFRunLoopGetCurrent())
      }

    CFRunLoopRun()
  }

  // MARK: rendering
  private func render(user: User) {
    for organization in user.organizations {
      for (index, project) in organization.projects.enumerated() {
        Ui.info("[\(index)] \(Ui.emojify(project.status)) \(project.name)")
      }
    }
  }
}
