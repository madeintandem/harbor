import BrightFutures

typealias UserFuture<V> =
  Future<V, UserError>

protocol UserProvider {
  func save(_ user: User) -> UserFuture<User>
}

class UserRepo {
  private let provider: UserProvider

  init(provider: UserProvider) {
    self.provider = provider
  }

  func create(_ user: User) -> UserFuture<User> {
    return provider.save(user)
  }
}
