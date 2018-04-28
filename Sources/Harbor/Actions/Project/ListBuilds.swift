import BrightFutures

extension Project {
  public final class ListBuilds {
    // MARK: Output
    public typealias Payload
      = Future<Project, Failure>

    public enum Failure: Error {
      case nested(Error)
    }

    // MARK: Action
    let fetchBuilds: FetchBuilds.Service

    convenience init() {
      self.init(fetchBuilds: CodeshipFetchBuilds().call)
    }

    init(fetchBuilds: @escaping FetchBuilds.Service) {
      self.fetchBuilds = fetchBuilds
    }

    func call(for project: Project, inOrganization organization: Organization) -> Payload {
      return fetchBuilds(organization, project)
        .mapError(Failure.nested)
        .map { response in
          project.setJsonBuilds(response.builds)
          return project
        }
    }
  }
}
