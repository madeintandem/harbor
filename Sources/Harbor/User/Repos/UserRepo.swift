class UserRepo {
  func current() -> UserFuture<User?> {
    return UserFuture(value: nil)
  }
}
