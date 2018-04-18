import BrightFutures

extension User {
  public final class ListProjects {
    // MARK: Output
    public typealias Payload
      = Future<User, Failure>

    public enum Failure: Error {
      case hasNoOrganizations
      case fetchProjects(Error)
      case listBuilds(Error)
    }

    // MARK: Action
    private let users: UserRepo
    private let dataStore: Store

    public convenience init() {
      self.init(users: UserRepo(), dataStore: FileStore())
    }

    init(users: UserRepo, dataStore: Store) {
      self.users = users
      self.dataStore = dataStore
    }

    public func call() -> Payload {
      guard
        let user = users.current,
        let organization = user.organizations.first
        else {
          return .init(error: .hasNoOrganizations)
        }

      let service = CodeshipFetchProjects()
        .call(for: organization)
        .mapError(Failure.fetchProjects)

      return service
        .map { response in
          organization.setJsonProjects(response.projects)
          return organization
        }
        .flatMap { organization -> Future<Void, Failure> in
          self.listBuildsForProjects(in: organization)
        }
        .map { _ in user }
        .onSuccess { _ in
          self.dataStore.save(user, as: .user)
        }
    }

    private func listBuildsForProjects(in organization: Organization) -> Future<Void, Failure> {
      let projects = organization.projects

      return projects
        .traverse { project in Project.ListBuilds().call(for: project, in: organization) }
        .mapError(Failure.listBuilds)
        .asVoid()
    }
  }
}
