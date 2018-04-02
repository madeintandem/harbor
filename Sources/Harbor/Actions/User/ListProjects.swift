extension User {
  final class ListProjects {
    private let users: UserRepo

    init(_ users: UserRepo = UserRepo()) {
      self.users = users
    }

    func call() -> [Project] {
      return users.current?.projects ?? []
    }
  }
}
