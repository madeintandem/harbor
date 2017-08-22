import Foundation

public protocol RunLoop {
  func addTimer(_ timer: Timer, forMode mode: String)
}

extension Foundation.RunLoop : RunLoop {

}
