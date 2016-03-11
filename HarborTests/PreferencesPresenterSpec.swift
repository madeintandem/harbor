@testable import Harbor

import Quick
import Nimble
import Drip

class PreferencesPresenterSpec: HarborSpec {
  override func spec() {
    super.spec()

    var view: MockPreferencesView!
    var example: Example<PreferencesPresenter<MockPreferencesView>>!

    beforeEach{
      view = MockPreferencesView()

      example = Example { ex in
        ex.app.override(ex.projectsInteractor as ProjectsInteractor)
        ex.view.module(PreferencesViewModule.self) { PreferencesViewModule($0) }

        return ex.view.preferences.inject(view)
      }
    }

    describe("presentation cycle"){
      it("listens to the projectsProvider") {
        let invocation = Invocations.projectsInteractor(.AddListener, VerifierOf(None.Nothing))

        example.subject.didInitialize()
        expect(example.projectsInteractor.invocation).to(match(invocation))
      }

      it("sets the needsRefresh flag properly") {
        example.subject.setNeedsRefresh()
        expect(example.subject.needsRefresh).to(beTrue())
      }

      it("refreshes the view when it appears") {
        example.subject.setNeedsRefresh()
        expect(example.subject.needsRefresh).to(beTrue())

        example.subject.didBecomeActive()
        expect(example.subject.needsRefresh).to(beFalse())
      }

      it("refreshes the view when it disappears") {
        example.subject.setNeedsRefresh()
        expect(example.subject.needsRefresh).to(beTrue())

        example.subject.didResignActive()
        expect(example.subject.needsRefresh).to(beFalse())
      }

      xit("updates the view when refreshing") {
        let invocation = Invocations.preferencesView(.UpdateApiKey, VerifierOf("asdf"))
        expect(view.invocations).to(haveAnyMatch(invocation))
      }
    }
  }
}