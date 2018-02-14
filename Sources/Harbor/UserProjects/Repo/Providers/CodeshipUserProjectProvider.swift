final class CodeshipUserProjectsProvider: UserProjectProvider {
  func fetch() -> UserProjectFuture<[Project]> {
    return CodeshipClient().request("/projects.json")
      .responseJson(onError: UserProjectError.network)
      .map { _ in [] }
  }
}
