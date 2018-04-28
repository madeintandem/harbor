protocol StoreProvider {
  func data() -> Store
  func secure() -> Store
}

struct Stores: StoreProvider {
  func data() -> Store {
    return FileStore()
  }

  func secure() -> Store {
    return KeychainStore()
  }
}


