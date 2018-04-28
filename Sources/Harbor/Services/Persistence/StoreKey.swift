struct StoreKey<T: Codable> {
  let key: String
  let type = T.self

  static var user: StoreKey<User> {
    return StoreKey<User>(key: "user")
  }

  static var credentials: StoreKey<Credentials> {
    return StoreKey<Credentials>(key: "credentials")
  }
}
