import Quick
import Nimble

@testable import Harbor

class TimerCoordinatorTests : HarborSpec {
  override func spec() {
    super.spec()

    var example: Example<TimerCoordinator>!

    beforeEach {
      example = Example(constructor: {
        return TimerCoordinator()
      })
    }

    it("the initializer observes the settings manager notification"){
      let invocation = Invocations.notification(.AddObserverForName, .RefreshRate)
      expect(example.notificationCenter.invocation).to(match(invocation))
    }

    describe("when starting a timer") {
      beforeEach {
        example.settings.refreshRate = 60.0
      }

      it("should not create a timer when the refresh rate is 0.0") {
        example.settings.refreshRate = 0.0

        let timer = example.subject.startTimer()
        expect(timer).to(beNil())
      }

      it("creates a timer") {
        let timer = example.subject.startTimer()
        expect(timer).toNot(beNil())
        expect(timer!.timeInterval).to(equal(example.settings.refreshRate))
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