public enum Status: String, Codable {
  case passed   = "passed"
  case failed   = "failed"
  case building = "building"
  case unknown  = "unknown"
}

extension Status {
  typealias Json = FetchBuilds.Response.Build

  // MARK: JSON factories
  static func fromJson(_ json: Json) -> Status {
    switch json.status {
      case "success":
        return .passed
      case "failed", "error":
        return .failed
      default:
        return .unknown
    }
  }
}
