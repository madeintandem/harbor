
typealias ProjectHandler = ([Project]) -> Void

// TODO: rename this to ProjectsProviderType
protocol ProjectsInteractor {
  func refreshProjects()
  func refreshCurrentProjects()
  func addListener(_ listener: @escaping ProjectHandler)
}
