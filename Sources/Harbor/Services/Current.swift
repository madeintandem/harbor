struct Current {
  private var user: User?
  private var session: Session?

  // static interface
  static var shared = Current()

  static var user: User? {
    get {
      return shared.user
    }
    set {
      shared.user = newValue
    }
  }
}
