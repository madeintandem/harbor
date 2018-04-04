public final class Project: Codable {
  let id: String
  let name: String
  let url: String

  init(from project: FetchProjects.Response.Project) {
    self.id = project.id
    self.name = project.name
    self.url = project.repositoryUrl
  }
}

extension Project: CustomStringConvertible {
  public var description: String {
    return name
  }
}
