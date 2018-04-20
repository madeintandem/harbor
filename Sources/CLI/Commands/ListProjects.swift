import Foundation
import BrightFutures
import Harbor

struct ListProjects {
  func call() {
    Ui.Loading.start()

    Future.Batch
      .head(User.SignInCurrent().call)
      .tail(User.ListProjects().call)
      .onSuccess(callback: render)
      .onFailure(callback: renderError)
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

  private func renderError(error: Error) {
    Ui.error("failed to list projects: \(error)")
  }
}
