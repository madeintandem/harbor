final class CodeshipUserProvider: UserProvider {
  func save(_ user: User) -> UserFuture<User> {
    return UserFuture(value: user)
  }
}
