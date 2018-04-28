import BrightFutures

extension User {
  public final class ListProjects {
    // MARK: Output
    public typealias Payload
      = Future<User, Failure>

    public enum Failure: Error {
      case hasNoUser
      case nested(Error)
    }

    // MARK: Action
    private let fetchProjects: FetchProjects.Service
    private let users: UserRepo
    private let stores: StoreProvider

    public convenience init() {
      self.init(
        fetchProjects: CodeshipFetchProjects().call,
        users: UserRepo(),
        stores: Stores()
      )
    }

    init(
      fetchProjects: @escaping FetchProjects.Service,
      users: UserRepo,
      stores: StoreProvider
    ) {
      self.fetchProjects = fetchProjects
      self.users = users
      self.stores = stores
    }

    public func call() -> Payload {
      guard let user = users.current else {
        return .init(error: .hasNoUser)
      }

      return user.organizations
        .traverse(f: self.listProjects)
        .map { _ in user }
        .onSuccess { user in
          self.stores.data().save(.user, record: user)
        }
    }

    // MARK: Helpers
    private func listProjects(for organization: Organization) -> Future<Void, Failure> {
      return fetchProjects(organization)
        .mapError(Failure.nested)
        .map { response in
          organization.setJsonProjects(response.projects)
          return organization
        }
        .flatMap { organization -> Future<Void, Failure> in
          self.listBuildsForProjects(in: organization)
        }
    }

    private func listBuildsForProjects(in organization: Organization) -> Future<Void, Failure> {
      return organization.projects
        .traverse { project in
          Project.ListBuilds().call(for: project, inOrganization: organization)
        }
        .mapError(Failure.nested)
        .asVoid()
    }
  }
}
