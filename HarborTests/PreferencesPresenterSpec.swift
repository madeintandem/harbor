@testable import Harbor

import Quick
import Nimble
import Drip

class PreferencesPresenterSpec: HarborSpec { override func spec() {
  var subject:   PreferencesPresenter<MockPreferencesView>!

  // MARK: Dependencies
  var view:     MockPreferencesView!
  var provider: MockProjectsProvider!
  var settings: MockSettings!
  var timers:   MockTimerCoordinator!

  beforeEach {
    view     = MockPreferencesView()
    provider = MockProjectsProvider()
    settings = MockSettings()
    timers   = MockTimerCoordinator()

    subject = PreferencesPresenter(
      view: view,
      projectsInteractor: provider,
      settings: settings,
      timerCoordinator: timers)
  }

  describe("#didInitialize") {
    it("listens to the projectsProvider") {
      subject.didInitialize()

      let invocation = Invocations.projectsInteractor(.AddListener, VerifierOf(None.Nothing))
      expect(provider.invocation).to(match(invocation))
    }
  }

  describe("#setNeedsRefresh") {
    it("sets the needsRefresh flag properly") {
      subject.setNeedsRefresh()
      expect(subject.needsRefresh).to(beTrue())
    }
  }

  describe("#didBecomeActive") {
    context("when needsRefresh is true") {
      beforeEach {
        subject.setNeedsRefresh()
      }

      it("refreshes the view") {
        expect(subject.needsRefresh).to(beTrue())
        subject.didBecomeActive()
        expect(subject.needsRefresh).to(beFalse())
      }
    }
  }

  describe("#didResignActive") {
    context("when needsRefresh is true") {
      beforeEach {
        subject.setNeedsRefresh()
      }

      it("refreshes the view when it disappears") {
        expect(subject.needsRefresh).to(beTrue())
        subject.didResignActive()
        expect(subject.needsRefresh).to(beFalse())
      }
    }
  }

  describe("#updateLaunchOnLogin") {
    beforeEach {
      subject.setNeedsRefresh()
    }

    it("updates launchOnLogin to user selection") {
      subject.updateLaunchOnLogin(true)
      expect(subject.launchOnLogin).to(beTrue())
      subject.updateLaunchOnLogin(false)
      expect(subject.launchOnLogin).to(beFalse())
      subject.updateLaunchOnLogin(true)
      expect(subject.launchOnLogin).to(beTrue())
    }
  }

  describe("#savePreferences") {
    beforeEach {
      subject.updateApiKey("abc123")
      subject.updateRefreshRate("10")
      subject.updateLaunchOnLogin(true)
      subject.setNeedsRefresh()
      subject.savePreferences()
    }

    it("updates settings"){
      expect(settings.apiKey) == "abc123"
      expect(settings.refreshRate) == Int("10")
      expect(settings.launchOnLogin) == true
      expect(subject.needsRefresh).to(beFalse())
    }
  }

  describe("on refresh") {
    func refresh() {
      subject.setNeedsRefresh()
      subject.didBecomeActive()
    }

    it("updates the view's api key") {
      settings.apiKey = "test-key"
      refresh()
      expect(view.apiKey) == "test-key"
    }
  }
}}