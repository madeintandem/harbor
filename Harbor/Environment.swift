enum Environment {
  case debug
  case release
  case testing

  static var active: Environment {
    #if TEST
      return .testing
    #elseif DEBUG
      return .debug
    #else
      return .release
    #endif
  }
}
