import Foundation
import Commander
import BrightFutures
import Harbor

struct ListBuilds {
  // MARK: Output
  enum Failure: Error {
    case hasNoQuery
  }

  // MARK: Command
  func call(path: Path?) throws {
    guard let path = path else {
      throw Failure.hasNoQuery
    }

    Ui.Loading.start()

    Future.Batch
      .head(
        User.SignInCurrent().call
      )
      .tail(
        Project.ListBuildsByPosition()
          .call(for: path.project, inOrganization: path.organization)
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
    let usernameLength = project.builds
      .map { $0.commit.username.count }
      .max(by: <) ?? 0

    Ui.head("\(Ui.emojify(project.status)) \(project.name)")

    for build in project.builds {
      let username = build.commit.username.padding(toLength: usernameLength, withPad: " ", startingAt: 0)
      Ui.info("\(Ui.emojify(build.status)) \(username) \(build.commit.message)")
    }
  }

  private func renderError(error: Error) {
    Ui.error("failed to list projects: \(error)")
  }
}

// MARK: Arguments
extension ListBuilds {
  struct Path: ArgumentConvertible {
    let organization: Int
    let project: Int

    init(parser: ArgumentParser) throws {
      guard let value = parser.shift() else {
        throw ArgumentError.missingValue(argument: nil)
      }

      guard
        value.count == 2,
        let org = Ui.code(from: value, offset: 0, inRange: .numbers),
        let project = Ui.code(from: value, offset: 1, inRange: .letters)
        else {
          throw ArgumentError.invalidType(value: value, type: "number", argument: nil)
        }

      self.organization = org
      self.project = project
    }

    var description: String {
        return "\(Ui.char(from: organization, inRange: .letters))\(Ui.char(from: project, inRange: .numbers))"
    }
  }
}
