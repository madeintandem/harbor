import Foundation
import Alamofire

enum CodeshipUrl {
  case auth
  case projects(String)
}

extension CodeshipUrl: URLConvertible {
  func asURL() throws -> URL {
    return try "https://api.codeship.com/v2\(endpoint())".asURL()
  }

  func endpoint() -> String {
    switch self {
      case .auth:
        return "/auth"
      case .projects(let id):
        return "/organizations/\(id)/projects"
    }
  }
}
