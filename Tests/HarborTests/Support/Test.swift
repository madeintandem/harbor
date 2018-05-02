import Foundation

struct Test {
  static func id() -> String {
    return UUID().uuidString
  }

  static func token() -> String {
    return id().replacingOccurrences(of: "-", with: "")
  }
}
