final class SignInUser {
  private let users: UserRepo
  private let sessions: UserSessionRepo

  init (users: UserRepo, sessions: UserSessionRepo) {
    self.users = users
    self.sessions = sessions
  }

  func signIn() -> UserFuture<User?> {
    let user = users
      .current()

    let session = user
      .flatMap(self.buildValidParams)
      .flatMap(sessions.create)

    return user
      .zip(session)
      .map { (pair) in pair.0?.signIn(with: pair.1) }
  }

  private func buildValidParams (from user: User?) -> UserFuture<UserSessionParams> {
    guard let user = user else {
      return UserFuture(error: .notSignedIn)
    }

    guard
      let email = user.email,
      let password = user.password,
      email.isEmpty || password.isEmpty else {
        return UserFuture(error: .blankCredentials)
      }

    let params = UserSessionParams(
      email: email,
      password: password
    )

    return UserFuture(value: params)
  }
}
