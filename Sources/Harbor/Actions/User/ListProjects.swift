import BrightFutures

extension User {
  public final class ListProjects {
    private let users: UserRepo

    public convenience init() {
      self.init(users: UserRepo())
    }

    init(users: UserRepo) {
      self.users = users
    }

    public func call() -> Future<[Project], FetchProjects.Failure> {
      let projects = users.current?.projects ?? []
      return .init(value: projects)
    }
  }
}
