import Foundation

final class FileStore: Store {
  private let files = FileManager()
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  func save<T>(_ key: StoreKey<T>, record: T) -> Bool where T: Encodable {
    guard
      let json = try? encoder.encode(record),
      let url = buildFileUrl(for: key)
      else {
        return false
      }

    do {
      let dirUrl = url.deletingLastPathComponent()
      try files.createDirectory(at: dirUrl, withIntermediateDirectories: true, attributes: nil)
    } catch {
      return false
    }

    return files.createFile(atPath: url.path, contents: json, attributes: nil)
  }

  func load<T>(_ key: StoreKey<T>) -> T? where T: Decodable {
    guard
      let url = buildFileUrl(for: key),
      files.fileExists(atPath: url.path)
      else {
        return nil
      }

    do {
      let data = try Data(contentsOf: url)
      let entity = try decoder.decode(key.type, from: data)
      return entity
    } catch {
      return nil
    }
  }

  // MARK: helpers
  private func buildFileUrl<T>(for key: StoreKey<T>) -> URL? {
    guard
      let baseUrl = try? files.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      else {
        return nil
      }

    return baseUrl
      .appendingPathComponent("Harbor")
      .appendingPathComponent(key.key)
      .appendingPathExtension("json")
  }
}
