public final class User: Entity, Codable {
  private(set) var session: Session?

  public var id: String { return email }
  public let email: String
  public private(set) var organizations: [Organization] = []

  init(_ email: String) {
    self.email = email
  }

  func signIn(_ session: Session, _ organizations: [Organization]) {
    self.session = session
    self.organizations = organizations
  }
}
