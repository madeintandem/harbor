import BrightFutures

extension User {
  public final class ListProjects {
    private let fetchProjects: FetchProjects.Service

    public convenience init() {
      self.init(
        fetchProjects: CodeshipFetchProjects().call
      )
    }

    init(
      fetchProjects: @escaping FetchProjects.Service
    ) {
      self.fetchProjects = fetchProjects
    }

    public func call() -> Future<[Project], Failure> {
      return self.fetchProjects()
        .mapError(Failure.fetchProjects)
        .map { _ in [] }
    }

    public enum Failure: Error {
      case fetchProjects(Error)
    }
  }
}
