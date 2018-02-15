final class User {
  var email: String?
  var password: String?
  var session: Session?

  init (email: String?, password: String?) {
    self.email = email
    self.password = password
  }

  func signIn (with session: Session) -> User {
    self.session = session
    return self
  }
}
