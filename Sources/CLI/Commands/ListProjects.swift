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
      let orgCode = Ui.char(from: orgIndex, inRange: .numbers)
      Ui.head("(\(orgCode)) * \(org.name)")

      for (projectIndex, project) in org.projects.enumerated() {
        let projectCode = Ui.char(from: projectIndex, inRange: .letters)
        Ui.info("[\(projectCode)] \(Ui.emojify(project.status)) \(project.name)")
      }
    }
  }

  private func renderError(error: Error) {
    Ui.error("failed to list projects: \(error)")
  }
}
