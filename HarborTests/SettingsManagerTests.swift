import Quick
import Nimble

@testable import Harbor

class SettingsManagerTests: HarborSpec {
  override func spec() {
    super.spec()

    var example: Example<SettingsManager>!

    beforeEach {
      example = Example(constructor: {
        return SettingsManager()
      })
    }

    describe("Properties") {
      describe("the refresh rate") {
        it("updates its refresh rate") {
          let refreshRate = 60.0

          example.subject.refreshRate = refreshRate
          expect(example.subject.refreshRate).to(equal(60.0))
        }

        it("sends the user defaults the given rate"){
          let value      = 60.0
          let invocation = Invocations.defaults(.SetDouble, VerifierOf(value))

          example.subject.refreshRate = value
          expect(example.defaults.invocation).to(match(invocation))
        }

        it("posts a notification") {
          let invocation = Invocations.notification(.PostNotificationName, .RefreshRate)
          example.subject.refreshRate = 60.0
          expect(example.notificationCenter.invocation).to(match(invocation))
        }
      }

      describe("the API Key") {
        let apiKey = "9900alk00sd52fjsadlkjfsal"

        it("updates its API Key") {
          example.subject.apiKey = apiKey
          expect(example.subject.apiKey).to(equal(apiKey))
        }

        it("sets the API Key in the keychain"){
          let invocation = Invocations.keychain(.SetString, VerifierOf(apiKey))

          example.subject.apiKey = apiKey
          expect(example.keychain.invocation).to(match(invocation))
        }

        it("posts a notification") {
          let invocation = Invocations.notification(.PostNotificationName, .ApiKey)

          example.subject.apiKey = apiKey
          expect(example.notificationCenter.invocation).to(match(invocation))
        }
      }

      describe("the disabled projects array") {
        let disabledProjectIds = [3, 17, 23, 50]

        it("updates its disabled projects") {
          example.subject.disabledProjectIds = disabledProjectIds
          expect(example.subject.disabledProjectIds).to(equal(disabledProjectIds))
        }

        it("sends user defaults the disabled project id array"){
          let invocation = Invocations.defaults(.SetObject, VerifierOf(disabledProjectIds))

          example.subject.disabledProjectIds = disabledProjectIds
          expect(example.defaults.invocation).to(match(invocation))
        }

        it("posts a notification") {
          let invocation = Invocations.notification(.PostNotificationName, .DisabledProjects)

          example.subject.disabledProjectIds = disabledProjectIds
          expect(example.notificationCenter.invocation).to(match(invocation))
        }
      }
    }

    describe("notification extension") {
      describe("observeNotification") {
        it("should add an observer to notification center") {
          let notification = SettingsManager.NotificationName.ApiKey
          let invocation   = Invocations.notification(.AddObserverForName, notification)

          example.subject.observeNotification(notification, handler: { _ in })
          expect(example.notificationCenter.invocation).to(match(invocation))
        }
      }
    }

    describe("initializer"){
      it("retrieves the correct API Key") {
        let apiKey = "12903jasjfd0aj21"
        example.subject.apiKey = apiKey

        let local = example.rebuild()
        expect(local.subject.apiKey).to(equal(apiKey))
      }

      it("retrieves the correct refresh rate"){
        let refreshRate = 60.0
        example.subject.refreshRate = refreshRate

        let local = example.rebuild()
        expect(local.subject.refreshRate).to(equal(refreshRate))
      }

      it("retrieves the correct disabled project ids"){
        let disabledProjectIds = [1, 2, 3, 4]
        example.subject.disabledProjectIds = disabledProjectIds

        let local = example.rebuild()
        expect(local.subject.disabledProjectIds).to(equal(disabledProjectIds))
      }
    }
  }
}
