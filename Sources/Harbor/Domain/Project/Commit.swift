public struct Commit: Codable {
  public let sha: String
  public let username: String
  public let message: String
}

extension Commit {
  typealias Json = FetchBuilds.Response.Build

  // MARK: zero
  static let zero = Commit(
    sha: "",
    username: "",
    message: ""
  )

  // MARK: JSON factories
  static func fromJson(_ json: Json) -> Commit {
    return Commit(
      sha: json.commitSha,
      username: json.username,
      message: json.commitMessage
    )
  }
}
