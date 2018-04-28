import Foundation
import KeychainAccess

final class KeychainStore: Store {
  private let keychain = Keychain(service: "com.devmynd.harbor")
  private let encoder  = JSONEncoder()
  private let decoder  = JSONDecoder()

  func save<T>(_ key: StoreKey<T>, record: T) -> Bool where T: Encodable {
    guard let json = try? encoder.encode(record) else {
      return false
    }

    do {
      try keychain.set(json, key: key.key)
    } catch {
      return false
    }

    return true
  }

  func load<T>(_ key: StoreKey<T>) -> T? where T: Decodable {
    guard
      let payload = try? keychain.getData(key.key),
      let data = payload
      else {
        return nil
      }

    return try? decoder.decode(key.type, from: data)
  }
}
