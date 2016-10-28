@testable import Harbor

import Quick
import Nimble
import Drip

class TimerCoordinatorSpec: HarborSpec {
  override func spec() {
    super.spec()

    var example: Example<TimerCoordinatorType>!

    beforeEach {
      example = Example { ex in
        ex.app
          .override(ex.runLoop as RunLoop)
          .override(ex.notificationCenter as NotificationCenter)
          .override(ex.projectsInteractor as ProjectsInteractor)

        return ex.app.interactor.inject()
      }
    }

    describe("the initializer") {
      it("observes the settings' refresh rate"){
        let invocation = Invocations.notification(.AddObserverForName, .RefreshRate)
        expect(example.notificationCenter.invocation).to(match(invocation))
      }
    }

    describe("when starting a timer") {
      beforeEach {
        example.settings.refreshRate = 60
      }

      it("should not create a timer when the refresh rate is 0.0") {
        example.settings.refreshRate = 0

        let timer = example.subject.startTimer()
        expect(timer).to(beNil())
      }

      it("creates a timer") {
        let timer = example.subject.startTimer()
        let refreshRateAsDouble = Double(example.settings.refreshRate)
        expect(timer).toNot(beNil())
        expect(timer!.timeInterval).to(equal(refreshRateAsDouble))
      }

      it("adds the timer to the run loop") {
        let timer = example.subject.startTimer()
        let invocation = Invocations.runloop(.AddTimer, VerifierOf(timer))

        expect(example.runLoop.invocation).to(match(invocation))
      }

      context("when there's an existing timer") {
        it("cancels the existing timer") {
          let existingTimer = example.subject.startTimer()
          let currentTimer = example.subject.startTimer()
          
          expect(existingTimer?.valid).to(beFalse())
          expect(existingTimer).toNot(equal(currentTimer))
        }
      }
    }
  }
}