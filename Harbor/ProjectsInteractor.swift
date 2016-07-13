
typealias ProjectHandler = ([Project] -> Void)

// TODO: rename this to ProjectsProviderType
protocol ProjectsInteractor {
  func refreshProjects()
  func refreshCurrentProjects()
  func addListener(listener: ProjectHandler)
}
