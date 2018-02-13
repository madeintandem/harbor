class ProjectRepo {
  private let provider: ProjectProvider

  init (provider: ProjectProvider) {
    self.provider = provider
  }

  func all() -> [Project] {
    return [
      Project(name: "test")
    ]
  }
}
