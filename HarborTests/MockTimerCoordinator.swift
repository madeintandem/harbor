import Foundation
@testable import Harbor

class MockTimerCoordinator: TimerCoordinatorType {
  func startup() {
  }

  func startTimer() -> Timer? {
    return nil
  }

  func stopTimer() {
  }
}
