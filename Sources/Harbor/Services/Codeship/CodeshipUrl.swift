import Foundation
import Alamofire

enum CodeshipUrl {
  case auth
  case projects(Organization)
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
    }
  }
}
