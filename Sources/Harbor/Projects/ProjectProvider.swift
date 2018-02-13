import Result

enum ProjectError: Error {
  case network(Int)
}

protocol ProjectProvider {
  func getProjects (handler: @escaping (Result<[AnyObject], ProjectError>) -> ())
}
