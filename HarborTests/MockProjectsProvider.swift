@testable import Harbor

class MockProjectsProvider : ProjectsInteractor {
  enum Method : MethodType {
    case refreshProjects
    case refreshCurrentProjects
    case addListener
  }

  let projects  : [Project]
  var invocation: Invocation<Method>?

  init() {
    projects = MockCodeshipApi().generateProjects()
  }

  func refreshProjects(){
    invocation = Invocation(.refreshProjects, None.nothing)
  }

  func refreshCurrentProjects(){
    invocation = Invocation(.refreshCurrentProjects, None.nothing)
  }

  func addListener(_ listener: ProjectHandler){
    invocation = Invocation(.addListener, None.nothing)
    listener(self.projects)
  }
}

extension Invocations {
  static func projectsInteractor<E: Verifiable>(_ method: MockProjectsProvider.Method, _ value: E) -> ExpectedInvocation<MockProjectsProvider.Method, E> {
    return ExpectedInvocation(method, value)
  }
}
