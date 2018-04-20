import Foundation
import BrightFutures
import Harbor

struct ListBuilds {
  func call(orgIndex: Int, projectIndex: Int) {
    Ui.Loading.start()

    Future.Batch
      .head(
        User.SignInCurrent().call
      )
      .tail(
        Project.ListBuildsByPosition()
          .call(for: projectIndex, inOrganization: orgIndex)
      )
      .onSuccess(callback: render)
      .onFailure(callback: renderError)
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

  private func renderError(error: Error) {
    Ui.error("failed to list projects: \(error)")
  }
}
