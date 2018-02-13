import Quick
import Nimble

@testable import Harbor

class MockProvider: ProjectProvider {
  func getProjects (handler: @escaping (Result<[AnyObject], ProjectError>) -> ()) {
    return .success([])
  }
}

class ProjectRepoSpec: QuickSpec { override func spec() {
  let subject = ProjectRepo(provider: MockProvider())

  describe("#all") {
    it("gets all projects") {
      let actual = subject.all()
      expect(actual.map { $0.name }) == ["test"]
    }
  }
}}
