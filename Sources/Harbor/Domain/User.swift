final class User {
  private(set) var email: String?
  private(set) var password: String?
  private(set) var session: Session?
  private(set) var projects: [Project] = []

  init(email: String?, password: String?) {
    self.email = email
    self.password = password
  }

  func signIn(with session: Session) {
    self.session = session
  }

  func setProjects (projects: [Project]) {
    self.projects = projects
  }
}
