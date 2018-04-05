import BrightFutures

extension User {
  public final class ListProjects {
    private let users: UserRepo
    private let fetchProjects: FetchProjects.Service

    public convenience init() {
      self.init(
        users: UserRepo(),
        fetchProjects: CodeshipFetchProjects().call
      )
    }

    init(
      users: UserRepo,
      fetchProjects: @escaping FetchProjects.Service
    ) {
      self.users = users
      self.fetchProjects = fetchProjects
    }

    public func call() -> Future<[Project], Failure> {
      guard
        let organization = users.current?.organizations.first
        else {
          return .init(error: .hasNoOrganizations)
        }

      return self.fetchProjects(organization)
        .mapError(Failure.fetchProjects)
        .map { response in
          return response.projects
            .map { data in Project(from: data) }
        }
    }

    public enum Failure: Error {
      case hasNoOrganizations
      case fetchProjects(Error)
    }
  }
}
