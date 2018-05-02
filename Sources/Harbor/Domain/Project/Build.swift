public final class Build: Entity, Codable {
  public let id: String
  public private(set) var url    = ""
  public private(set) var status = Status.unknown
  public private(set) var commit = Commit.zero

  init(_ id: String) {
    self.id = id
  }
}

extension Build {
  typealias Json = FetchBuilds.Response.Build

  // MARK: JSON updates
  func setJson(_ json: Json) {
    url    = json.links.pipelines
    status = Status.fromJson(json)
    commit = Commit.fromJson(json)
  }

  // MARK: JSON factories
  static func fromJson(_ json: Json) -> Build {
    let project = Build(json.uuid)
    project.setJson(json)
    return project
  }

  static func fromJson(_ json: [Json]) -> [Build] {
    return json.map { .fromJson($0) }
  }
}
