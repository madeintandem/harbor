import Alamofire
import BrightFutures

public struct FetchProjects {
  // service
  public typealias Service
    = () -> Future<[Project], Failure>

  // output
  public enum Failure: Error {
    case network(Error?)
  }
}
