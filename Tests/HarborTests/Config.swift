import Quick

@testable import Harbor
@testable import BrightFutures

class Config: QuickConfiguration {
  override class func configure(_ config: Configuration) {
    // automatically run futures
    DefaultThreadingModel = { ImmediateOnMainExecutionContext }

    // blow away current user each test
    config.beforeEach {
      Current.user = nil
    }
  }
}
