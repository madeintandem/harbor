import Quick

@testable import Harbor
@testable import BrightFutures

class Config: QuickConfiguration {
  override class func configure(_ config: Configuration) {
    // automatically run futures
    BrightFutures.DefaultThreadingModel = { ImmediateOnMainExecutionContext }

    // always reset current user
    config.beforeEach {
      Current.user = nil
    }
  }
}
