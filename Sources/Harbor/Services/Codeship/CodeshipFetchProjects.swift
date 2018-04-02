import Alamofire
import BrightFutures

final class CodeshipFetchProjects {
  func call() -> Future<[Project], FetchProjects.Failure> {
    return Alamofire
      .request(CodeshipUrl.projects)
      .responseJson(onError: FetchProjects.Failure.network)
      .map { _ in [] }
  }
}
