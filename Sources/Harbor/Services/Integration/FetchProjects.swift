import Alamofire
import BrightFutures
import Domain

struct FetchProjects {
  // service
  typealias Service
    = () -> Future<[Project], Failure>

  // output
  enum Failure: Error {
    case network(Error?)
  }
}
