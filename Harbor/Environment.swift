enum Environment {
  case debug
  case release
  case testing

  static var active: Environment {
    #if TEST
      return .Testing
    #elseif DEBUG
      return .Debug
    #else
      return .release
    #endif
  }
}
