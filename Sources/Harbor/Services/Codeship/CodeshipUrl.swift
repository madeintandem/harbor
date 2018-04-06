import Foundation
import Alamofire

enum CodeshipUrl {
  case auth
  case projects(Organization)
  case builds(Organization, Project)
}

extension CodeshipUrl: URLConvertible {
  func asURL() throws -> URL {
    return try "https://api.codeship.com/v2\(endpoint())".asURL()
  }

  func endpoint() -> String {
    switch self {
      case .auth:
        return "/auth"
      case .projects(let org):
        return "/organizations/\(org.id)/projects"
      case .builds(let org, let project):
        return "/organizations/\(org.id)/projects/\(project.id)/builds?per_page=5"
    }
  }
}
