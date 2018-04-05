import Foundation
import Alamofire
import BrightFutures

struct FetchBuilds {
  // service
  typealias Service
    = (Organization, Project) -> Future<Response, Failure>

  // output
  enum Failure: Error {
    case unauthenticated
    case network(Error)
  }

  struct Response: Decodable {
    let builds: [Build]

    struct Build: Decodable {
      let uuid: String
      let username: String
      let commitSha: String
      let commitMessage: String
      let queuedAt: Date
      let finishedAt: Date
      let links: Links
    }

    struct Links: Decodable {
      let pipelines: String
    }
  }
}
