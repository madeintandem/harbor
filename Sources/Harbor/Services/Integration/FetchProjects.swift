import Foundation
import Alamofire
import BrightFutures

struct FetchProjects {
  // service
  typealias Service
    = (Organization) -> Future<Response, Failure>

  // output
  enum Failure: Error {
    case unauthenticated
    case network(Error)
  }

  struct Response: Decodable {
    let projects: [Project]

    struct Project: Decodable {
      let uuid: String
      let name: String
      let repositoryUrl: String
      let createdAt: Date
      let updatedAt: Date
    }
  }
}
