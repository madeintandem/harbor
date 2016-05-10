import Foundation

public protocol RunLoop {
  func addTimer(timer: NSTimer, forMode mode: String)
}

extension NSRunLoop : RunLoop {

}