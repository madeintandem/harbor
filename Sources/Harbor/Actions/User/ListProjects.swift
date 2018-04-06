import BrightFutures

extension User {
  public final class ListProjects {
    public typealias Payload = Future<[Project], Failure>

    private let users: UserRepo
    private let fetchProjects: FetchProjects.Service
    private let fetchBuilds: FetchBuilds.Service
    private let dataStore: Store

    public convenience init() {
      self.init(
        users: UserRepo(),
        fetchProjects: CodeshipFetchProjects().call,
        fetchBuilds: CodeshipFetchBuilds().call,
        dataStore: FileStore()
      )
    }

    init(
      users: UserRepo,
      fetchProjects: @escaping FetchProjects.Service,
      fetchBuilds: @escaping FetchBuilds.Service,
      dataStore: Store
    ) {
      self.users = users
      self.fetchProjects = fetchProjects
      self.fetchBuilds = fetchBuilds
      self.dataStore = dataStore
    }

    public func call() -> Payload {
      guard
        let user = users.current,
        let organization = user.organizations.first
        else {
          return .init(error: .hasNoOrganizations)
        }

      return self.fetchProjects(organization)
        .mapError(Failure.fetchProjects)
        .flatMap { response -> Payload in
          organization.setJsonProjects(response.projects)
          return self.fetchProjectBuilds(for: organization)
        }
        .onSuccess { _ in
          self.dataStore.save(user, as: .user)
        }

    }

    private func fetchProjectBuilds(for organization: Organization) -> Payload {
      let projects = organization.projects

      return projects
        .map { project in self.fetchBuilds(organization, project) }
        .sequence()
        .mapError(Failure.fetchBuilds)
        .map { responses in
          for (project, response) in zip(projects, responses) {
            project.setJsonBuilds(response.builds)
          }

          return projects
        }
    }

    // errors
    public enum Failure: Error {
      case hasNoOrganizations
      case fetchProjects(Error)
      case fetchBuilds(Error)
    }
  }
}
