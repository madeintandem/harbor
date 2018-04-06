enum Status: String, Codable {
  case passed   = "passed"
  case failed   = "failed"
  case building = "building"
  case unknown  = "unknown"
}

extension Status {
  typealias Json = FetchBuilds.Response.Build

  // MARK: json factories
  static func fromJson(_ json: Json) -> Status {
    switch json.status {
      case "success":
        return .passed
      case "failed":
        return .failed
      default:
        return .unknown
    }
  }
}
