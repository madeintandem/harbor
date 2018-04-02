import Alamofire

struct CodeshipFetchProjects: AnyFetchProjects {
  func call() -> FetchProjectsFuture<[Project]> {
    return Alamofire
      .request(CodeshipUrl.projects)
      .responseJson(onError: FetchProjectsError.network)
      .map { _ in [] }
  }
}
