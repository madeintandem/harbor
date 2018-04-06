public final class Organization: Codable {
  let id: String
  private(set) var projects: [Project] = []

  init(_ id: String) {
    self.id = id
  }
}

extension Organization {
  typealias Json = Auth.Response.Organization

  // MARK: json updates
  func setJsonProjects(_ json: [Project.Json]) {
    projects = Project.fromJson(json)
  }

  // MARK: json factories
  static func fromJson(_ json: Json) -> Organization {
    return Organization(json.uuid)
  }

  static func fromJson(_ json: [Json]) -> [Organization] {
    return json.map { .fromJson($0) }
  }
}

