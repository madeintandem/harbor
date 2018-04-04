public final class Organization: Codable {
  let id: String
  var projects: [Project] = []

  init(id: String) {
    self.id = id
  }
}
