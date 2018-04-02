import BrightFutures

extension User {
  final class ListProjects {
    private let users: UserRepo

    init(_ users: UserRepo = UserRepo()) {
      self.users = users
    }

    func call() -> Future<[Project], FetchProjects.Failure> {
      let projects = users.current?.projects ?? []
      return .init(value: projects)
    }
  }
}
