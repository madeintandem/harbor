public protocol Entity: Equatable {
  var id: String { get }
}

public func ==<E: Entity>(lhs: E, rhs: E) -> Bool {
  return lhs.id == rhs.id
}
