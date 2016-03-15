@testable import Harbor

import Drip

class Example<T> {
  //
  // MARK: Subject
  private let constructor: Example<T> -> T

  var subject: T!

  //
  // MARK: Components
  lazy var app: AppComponent = AppComponent()
    .module(InteractorModule.self) { InteractorModule($0) }
    .module(ServiceModule.self) { ServiceModule($0) }
    .module(SystemModule.self) { SystemModule($0) }

  lazy var view: ViewComponent = ViewComponent()
    .parent { self.app }

  //
  // MARK: Dependencies
  lazy var api = MockCodeshipApi()
  lazy var runLoop = MockRunLoop()
  lazy var keychain = MockKeychain()
  lazy var defaults = MockUserDefaults()

  lazy var settings: SettingsManager = self.app.interactor.inject()
  lazy var projectsInteractor = MockProjectsProvider()
  lazy var notificationCenter = MockNotificationCenter()

  //
  // MARK: Lifecycle
  init(_ constructor: Example<T> -> T) {
    self.constructor = constructor
    subject = constructor(self)
  }

  func rebuild(update: (Example<T> -> Void)? = nil) -> Example<T> {
    let original = constructor

    return Example { copy in
      update?(copy)
      return original(copy)
    }
  }
}