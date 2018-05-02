public final class Project: Entity, Codable {
  public let id: String
  public private(set) var name:   String = ""
  public private(set) var url:    String = ""
  public private(set) var builds: [Build] = []

  init(_ id: String) {
    self.id = id
  }

  public var status: Status {
    return builds.first?.status ?? .unknown
  }
}

extension Project {
  typealias Json = FetchProjects.Response.Project

  // MARK: JSON updates
  func setJson(_ json: Json) {
    name = json.name
    url  = json.repositoryUrl
  }

  func setJsonBuilds(_ json: [Build.Json]) {
    builds = Build.fromJson(json)
  }

  // MARK: JSON factories
  static func fromJson(_ json: Json) -> Project {
    let project = Project(json.uuid)
    project.setJson(json)
    return project
  }

  static func fromJson(_ json: [Json]) -> [Project] {
    return json.map { .fromJson($0) }
  }
}
