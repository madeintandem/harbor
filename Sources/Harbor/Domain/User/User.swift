public final class User: Codable {
  public let email: String
  public private(set) var organizations: [Organization] = []
  private(set) var session: Session?

  init(_ email: String) {
    self.email = email
  }

  func signIn(_ session: Session, _ organizations: [Organization]) {
    self.session = session
    self.organizations = organizations
  }
}
