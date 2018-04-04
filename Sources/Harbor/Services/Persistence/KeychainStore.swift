import Foundation
import KeychainAccess

final class KeychainStore: Store {
  private let keychain = Keychain(service: "com.devmynd.harbor")
  private let encoder  = JSONEncoder()
  private let decoder  = JSONDecoder()

  func save<T>(_ entity: T, as key: StoreKey) -> Bool where T: Encodable {
    guard let json = try? encoder.encode(entity) else {
      return false
    }

    do {
      try keychain.set(json, key: key.rawValue)
    } catch {
      return false
    }

    return true
  }

  func load<T>(_ type: T.Type, key: StoreKey) -> T? where T: Decodable {
    guard
      let payload = try? keychain.getData(key.rawValue),
      let data = payload
      else {
        return nil
      }

    return try? decoder.decode(type, from: data)
  }
}
