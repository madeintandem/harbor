import Foundation

struct Session: Equatable, Codable {
  let accessToken: String
  let expiresAt:   Date

  // accessors
  var isActive: Bool {
    get {
      return expiresAt.timeIntervalSinceNow > 0
    }
  }
}
