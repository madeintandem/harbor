protocol Store {
  @discardableResult
  func save<T>(_ key: StoreKey<T>, record: T) -> Bool
  func load<T>(_ key: StoreKey<T>) -> T?
}
