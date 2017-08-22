import Foundation

protocol TimerCoordinatorType {
  func startup()
  func startTimer() -> Timer?
  func stopTimer()
}
