import Foundation
import Harbor

struct Projects {
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
  private func render(projects: [Project]) {
    for (index, project) in projects.enumerated() {
      Ui.info("[\(index)] \(emojify(project.status)) \(project.name)")
    }
  }

  private func emojify(_ status: Status) -> String {
    switch status {
      case .passed:
        return "✔"
      case .failed:
        return "✘"
      case .building:
        return "Δ"
      case .unknown:
        return "?"
    }
  }
}
