protocol Store {
  @discardableResult
  func save<T>(_ entity: T, as key: StoreKey) -> Bool where T: Encodable
  func load<T>(_ type: T.Type, key: StoreKey) -> T? where T: Decodable
}
