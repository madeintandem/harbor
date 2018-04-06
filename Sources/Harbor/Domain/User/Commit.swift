struct Commit: Codable {
  let sha: String
  let username: String
  let message: String
}

extension Commit {
  typealias Json = FetchBuilds.Response.Build

  // MARK: zero
  static let zero = Commit(
    sha: "",
    username: "",
    message: ""
  )

  // MARK: json factories
  static func fromJson(_ json: Json) -> Commit {
    return Commit(
      sha: json.commitSha,
      username: json.username,
      message: json.commitMessage
    )
  }
}
