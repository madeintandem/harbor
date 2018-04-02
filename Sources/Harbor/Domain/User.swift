public final class User {
  private(set) var email: String?
  private(set) var session: Session?
  private(set) var projects: [Project] = []

  init(email: String?) {
    self.email = email
  }

  func signIn(with session: Session) {
    self.session = session
  }
}
