import BrightFutures

extension Project {
  public final class ListBuilds {
    // MARK: Output
    public typealias Payload
      = Future<[Build], Failure>

    public enum Failure: Error {
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

    func call(for project: Project, in organization: Organization) -> Payload {
      return CodeshipFetchBuilds()
        .call(for: organization, project: project)
        .mapError(Failure.fetchBuilds)
        .map { response in
          project.setJsonBuilds(response.builds)
          return project.builds
        }
    }
  }
}
