protocol Store {
  @discardableResult
  func save<T>(entity: T, as key: StoreKey) -> Bool where T: Encodable
  func load<T>(type: T.Type, key: StoreKey) -> T? where T: Decodable
}
