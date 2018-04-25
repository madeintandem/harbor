import BrightFutures

extension Project {
  public final class ListBuildsByPosition {
    // MARK: Output
    public typealias Payload
      = Future<Project, Failure>

    public enum Failure: Error {
      case hasNoUser
      case hasNoOrganization(Int)
      case hasNoProject(Organization, Int)
      case nested(Error)
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
        return .init(error: .hasNoOrganization(orgIndex))
      }

      guard let project = org.projects[safe: projectIndex] else {
        return .init(error: .hasNoProject(org, projectIndex))
      }

      return ListBuilds()
        .call(for: project, inOrganization: org)
        .mapError(Failure.nested)
    }
  }
}
