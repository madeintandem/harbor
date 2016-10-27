import Foundation

public protocol Scheduler {
  func addTimer(timer: Timer, forMode mode: RunLoopMode)
}

extension RunLoop: Scheduler {
  public func addTimer(timer: Timer, forMode mode: RunLoopMode) {
    add(timer, forMode: mode)
  }
}
