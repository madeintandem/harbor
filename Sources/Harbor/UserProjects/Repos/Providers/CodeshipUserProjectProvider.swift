import Alamofire

final class CodeshipUserProjectsProvider: UserProjectProvider {
  func fetch() -> UserProjectFuture<[Project]> {
    return Alamofire
      .request(CodeshipUrl.projects)
      .responseJson(onError: UserProjectError.network)
      .map { _ in [] }
  }
}
