struct Current {
  private var user: User?
  private static var shared = Current()

  // static interface
  static var user: User? {
    get {
      return shared.user
    }
    set {
      shared.user = newValue
    }
  }
}
