import Foundation
@testable import Harbor

class MockTimerCoordinator: TimerCoordinatorType {
  func startup() {
  }

  func startTimer() -> NSTimer? {
    return nil
  }

  func stopTimer() {
  }
}