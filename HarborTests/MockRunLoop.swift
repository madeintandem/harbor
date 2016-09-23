@testable import Harbor

import Foundation

class MockRunLoop : RunLoop {
  enum Method : MethodType {
    case addTimer
  }

  var invocation: Invocation<Method>?

  func addTimer(_ timer: Timer, forMode mode: String){
    invocation = Invocation(.addTimer, timer)
  }
}

extension Invocations {
  static func runloop<E: Verifiable>(_ method: MockRunLoop.Method, _ value: E?) -> ExpectedInvocation<MockRunLoop.Method, E> {
    return ExpectedInvocation(method, value)
  }
}
