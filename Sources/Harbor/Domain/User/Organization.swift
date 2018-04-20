public final class Organization: Codable {
  let id: String

  public private(set) var name: String = ""
  public private(set) var projects: [Project] = []

  init(_ id: String) {
    self.id = id
  }
}

extension Organization {
  typealias Json = Auth.Response.Organization

  // MARK: JSON updates
  func setJson(_ json: Json) {
    name = json.name
  }

  func setJsonProjects(_ json: [Project.Json]) {
    projects = Project.fromJson(json)
  }

  // MARK: JSON factories
  static func fromJson(_ json: Json) -> Organization {
    let org = Organization(json.uuid)
    org.setJson(json)
    return org
  }

  static func fromJson(_ json: [Json]) -> [Organization] {
    return json.map { .fromJson($0) }
  }
}

