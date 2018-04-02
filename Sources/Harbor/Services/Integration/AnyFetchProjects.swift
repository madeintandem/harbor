import Alamofire
import BrightFutures
import Domain

// output
typealias FetchProjectsFuture<R>
  = Future<R, FetchProjectsError>

enum FetchProjectsError: Error {
  case network(Error?)
}

// service
protocol AnyFetchProjects {
  func call() -> FetchProjectsFuture<[Project]>
}
