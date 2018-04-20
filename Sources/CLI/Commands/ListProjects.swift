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
    for (orgIndex, org) in user.organizations.enumerated() {
      Ui.head("(\(Ui.charify(orgIndex))) * \(org.name)")

      for (projectIndex, project) in org.projects.enumerated() {
        Ui.info("[\(projectIndex)] \(Ui.emojify(project.status)) \(project.name)")
      }
    }
  }

  private func renderError(error: Error) {
    Ui.error("failed to list projects: \(error)")
  }
}
