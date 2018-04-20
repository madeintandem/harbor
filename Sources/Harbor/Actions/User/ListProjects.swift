import BrightFutures

extension User {
  public final class ListProjects {
    // MARK: Output
    public typealias Payload
      = Future<User, Failure>

    public enum Failure: Error {
      case hasNoUser
      case listBuilds(Error)
      case fetchProjects(Error)
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
      guard let user = users.current else {
        return .init(error: .hasNoUser)
      }

      return user.organizations
        .traverse(f: self.listProjects)
        .map { _ in user }
        .onSuccess { user in
          self.dataStore.save(user, as: .user)
        }
    }

    // MARK: Helpers
    private func listProjects(for organization: Organization) -> Future<Void, Failure> {
      return CodeshipFetchProjects()
        .call(for: organization)
        .mapError(Failure.fetchProjects)
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
        .mapError(Failure.listBuilds)
        .asVoid()
    }
  }
}
