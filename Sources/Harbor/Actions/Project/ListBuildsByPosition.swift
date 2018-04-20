import BrightFutures

extension Project {
  public final class ListBuildsByPosition {
    // MARK: Output
    public typealias Payload
      = Future<Project, Failure>

    public enum Failure: Error {
      case hasNoUser
      case hasNoOrganization
      case hasNoProject
      case listBuilds(Error)
    }

    // MARK: Action
    private let users: UserRepo

    public convenience init() {
      self.init(users: UserRepo())
    }

    init(users: UserRepo) {
      self.users = users
    }

    public func call(for projectIndex: Int, inOrganization orgIndex: Int) -> Payload {
      guard let user = users.current else {
        return .init(error: .hasNoUser)
      }

      guard let org = user.organizations[safe: orgIndex] else {
        return .init(error: .hasNoOrganization)
      }

      guard let project = org.projects[safe: projectIndex] else {
        return .init(error: .hasNoProject)
      }

      return ListBuilds()
        .call(for: project, inOrganization: org)
        .mapError(Failure.listBuilds)
    }
  }
}
