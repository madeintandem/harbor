enum Environment {
  case Debug
  case Release
  case Testing

  static var active: Environment {
    #if TEST
      return .Testing
    #elseif DEBUG
      return .Debug
    #else
      return .Release
    #endif
  }
}