@testable import Harbor

class MockProjectsProvider : ProjectsInteractor {

  enum Method : MethodType {
    case RefreshProjects
    case RefreshCurrentProjects
    case AddListener
  }

  let projects  : [Project]
  var invocation: Invocation<Method>?

  init() {
    projects = MockCodeshipApi().generateProjects()
  }

  func refreshProjects(){
    invocation = Invocation(.RefreshProjects, None.Nothing)
  }

  func refreshCurrentProjects(){
    invocation = Invocation(.RefreshCurrentProjects, None.Nothing)
  }

  func addListener(listener: ProjectHandler){
    invocation = Invocation(.AddListener, None.Nothing)
    listener(self.projects)
  }
}

extension Invocations {
  static func projectsInteractor<E: Verifiable>(method: MockProjectsProvider.Method, _ value: E) -> ExpectedInvocation<MockProjectsProvider.Method, E> {
    return ExpectedInvocation(method, value)
  }
}