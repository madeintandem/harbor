//@testable import Harbor
//
//import Quick
//import Nimble
//import Drip
//
//class ProjectsProviderSpec: HarborSpec {
//  override func spec() {
//    super.spec()
//
//    var example:  Example<ProjectsInteractor>!
//    var projects: [Project]?
//
//    beforeEach {
//      example = Example { ex in
//        ex.app
//          .override(ex.notificationCenter as NotificationCenter)
//          .override(ex.api as CodeshipApiType)
//        
//        return ex.app.interactor.inject()
//      }
//
//      example.subject.addListener { local in
//        projects = local
//      }
//    }
//
//    describe("refreshing projects") {
//      beforeEach {
//        example.api.mockProjects()
//        example.subject.refreshProjects()
//      }
//
//      it("refreshes all projects") {
//        expect(projects).to(equal(example.api.projects!))
//      }
//
//      it("updates the disabled projects when the disabledProjectIds change") {
//        let disabledIds = [0]
//
//        example.settings.disabledProjectIds = disabledIds
//        example.subject.refreshCurrentProjects()
//
//        expect(projects).to(allPass { project in
//          return !disabledIds.contains(project!.id) == project!.isEnabled
//        })
//      }
//    }
//
//    describe("when a listener is added"){
//      it("calls the listener back immediately with the current projects") {
//        let projects = [ Project(id: 5) ]
//
//        example.api.projects = projects
//        example.subject.refreshProjects()
//        example.subject.addListener { local in
//          expect(local).to(equal(projects))
//        }
//      }
//    }
//  }
//}
