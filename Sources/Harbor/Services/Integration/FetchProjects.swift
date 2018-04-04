import Alamofire
import BrightFutures

struct FetchProjects {
  // service
  typealias Service
    = () -> Future<Response, Failure>

  // output
  enum Failure: Error {
    case notAuthenticated
    case network(Error)
  }

  struct Response: Decodable {
  }
}
