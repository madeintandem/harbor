public final class User: Codable {
  public let email: String

  private(set) var session: Session?
  private(set) var organizations: [Organization] = []

  init(_ email: String) {
    self.email = email
  }

  func signIn(_ session: Session, _ organizations: [Organization]) {
    self.session = session
    self.organizations = organizations
  }
}
