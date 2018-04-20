import Foundation

struct Session: Equatable, Codable {
  let accessToken: String
  let expiresAt:   Date

  var isActive: Bool {
    get {
      return expiresAt.timeIntervalSinceNow > 0
    }
  }
}

extension Session {
  typealias Json = Auth.Response

  // MARK: JSON factories
  static func fromJson(_ json: Json) -> Session {
    return Session(
      accessToken: json.accessToken,
      expiresAt:   json.expiresAt
    )
  }
}
