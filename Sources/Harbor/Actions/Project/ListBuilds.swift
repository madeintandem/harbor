import BrightFutures

extension Project {
  public final class ListBuilds {
    // MARK: Output
    public typealias Payload
      = Future<Project, Failure>

    public enum Failure: Error {
      case hasNoOrganizations
      case hasNoProject
      case fetchBuilds(Error)
    }

    // MARK: Action
    private let users: UserRepo

    public convenience init() {
      self.init(users: UserRepo())
    }

    init(users: UserRepo) {
      self.users = users
    }

    public func call(for index: Int) -> Payload {
      guard
        let user = users.current,
        let organization = user.organizations.first
        else {
          return .init(error: .hasNoOrganizations)
        }

      guard
        let project = organization.projects[safe: index]
        else {
          return .init(error: .hasNoProject)
        }

      return call(for: project, in: organization)
    }

    func call(for project: Project, in organization: Organization) -> Payload {
      return CodeshipFetchBuilds()
        .call(for: organization, project: project)
        .mapError(Failure.fetchBuilds)
        .map { response in
          project.setJsonBuilds(response.builds)
          return project
        }
    }
  }
}
