public final class Build: Codable {
  let id: String

  init(_ id: String) {
    self.id = id
  }
}

extension Build {
  typealias Json = FetchBuilds.Response.Build

  // MARK: json updates
  func setJson(_ json: Json) {
  }

  // MARK: json factories
  static func fromJson(_ json: Json) -> Build {
    let project = Build(json.uuid)
    project.setJson(json)
    return project
  }

  static func fromJson(_ json: [Json]) -> [Build] {
    return json.map { .fromJson($0) }
  }
}
