import Foundation
import Alamofire

enum CodeshipUrl: String {
  case auth = "/auth"
  case projects = "/projects"
}

extension CodeshipUrl: URLConvertible {
  func asURL() throws -> URL {
    return try "https://api.codeship.com/v2\(rawValue)".asURL()
  }
}
