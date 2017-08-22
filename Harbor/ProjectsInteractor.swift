
typealias ProjectHandler = (([Project]) -> Void)

protocol ProjectsInteractor {
  func refreshProjects()
  func refreshCurrentProjects()
  func addListener(_ listener: @escaping ProjectHandler)
}
