@testable import Harbor

class MockCodeshipApi : CodeshipApiType {
  var projects: [Project]?

  init() {

  }

  func getProjects(_ successHandler:([Project]) -> (), errorHandler:(String) -> ()) {
    if let projects = self.projects {
      successHandler(projects)
    } else {
      errorHandler("nope")
    }
  }

  func mockProjects() {
    self.projects = self.generateProjects()
  }

  func generateProjects() -> [Project] {
    return (0...10).map { Project(id: $0) }
  }
}
