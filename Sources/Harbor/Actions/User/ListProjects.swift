import BrightFutures

extension User {
  public final class ListProjects {
    public typealias Payload = Future<[Project], Failure>

    private let users: UserRepo
    private let fetchProjects: FetchProjects.Service
    private let fetchBuilds: FetchBuilds.Service

    public convenience init() {
      self.init(
        users: UserRepo(),
        fetchProjects: CodeshipFetchProjects().call,
        fetchBuilds: CodeshipFetchBuilds().call
      )
    }

    init(
      users: UserRepo,
      fetchProjects: @escaping FetchProjects.Service,
      fetchBuilds: @escaping FetchBuilds.Service
    ) {
      self.users = users
      self.fetchProjects = fetchProjects
      self.fetchBuilds = fetchBuilds
    }

    public func call() -> Payload {
      guard
        let organization = users.current?.organizations.first
        else {
          return .init(error: .hasNoOrganizations)
        }

      return self.fetchProjects(organization)
        .mapError(Failure.fetchProjects)
        .flatMap { response -> Payload in
          organization.setJsonProjects(response.projects)
          return self.fetchProjectBuilds(for: organization)
        }
    }

    private func fetchProjectBuilds(for organization: Organization) -> Payload {
      let projects = organization.projects

      return projects
        .map { project in self.fetchBuilds(organization, project) }
        .sequence()
        .mapError(Failure.fetchBuilds)
        .map { responses in
          zip(projects, responses).map { project, response in
            project.setJsonBuilds(response.builds)
            return project
          }
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
