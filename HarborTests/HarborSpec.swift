import Quick
@testable import Harbor

class HarborSpec : QuickSpec {
  override func spec() {
    beforeEach {
      Injector
        .module(CoreModuleType.self, MockCoreModule()).start()
    }
  }
}