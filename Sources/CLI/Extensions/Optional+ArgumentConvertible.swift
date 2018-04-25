import Commander

extension Optional: ArgumentConvertible where Wrapped: ArgumentConvertible {
  public init(parser: ArgumentParser) throws {
    self = .some(try Wrapped(parser: parser))
  }
}

extension Optional: CustomStringConvertible where Wrapped: CustomStringConvertible {
  public var description: String {
    switch self {
      case .some(let value):
        return value.description
      case .none:
        return "nil"
    }
  }
}
