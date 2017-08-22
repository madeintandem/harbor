import Foundation

public protocol RunLoop {
  func add(_ timer: Timer, forMode mode: RunLoopMode)
}

extension Foundation.RunLoop: RunLoop {
}
