import Foundation

protocol TimerCoordinatorType {
  func startup()
  func startTimer() -> NSTimer?
  func stopTimer()
}
