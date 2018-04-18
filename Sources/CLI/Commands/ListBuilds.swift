
import Foundation
import Harbor

struct ListBuilds {
  func call(index: Int) {
    Ui.Loading.start()

    let operation = AnyFuture.serially(
      User.SignInCurrent()
        .call()
        .anytyped(),
      Project.ListBuilds()
        .call(for: index)
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
  private func render(project: Project) {
    let length = project.builds
      .map { $0.commit.username.count }
      .max(by: <) ?? 0

    for (index, build) in project.builds.enumerated() {
      let username = build.commit.username.padding(toLength: length, withPad: " ", startingAt: 0)
      Ui.info("[\(index)] \(Ui.emojify(build.status)) \(username) \(build.commit.message)")
    }
  }
}
