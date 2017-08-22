//@testable import Harbor
//
//import Drip
//
//class Example<T> {
//  //
//  // MARK: Subject
//  fileprivate let constructor: (Example<T>) -> T
//
//  var subject: T!
//
//  // MARK: Components
//  lazy var app: AppComponent = stubAppComponent()
//  lazy var view: ViewComponent = stubViewComponent()
//
//  //
//  // MARK: Dependencies
//  lazy var api      = MockCodeshipApi()
//  lazy var runLoop  = MockRunLoop()
//  lazy var keychain = MockKeychain()
//  lazy var defaults = MockUserDefaults()
//
//  lazy var settings: SettingsType = self.app.interactor.inject()
//  lazy var projectsInteractor = MockProjectsProvider()
//  lazy var notificationCenter = MockNotificationCenter()
//
//  //
//  // MARK: Lifecycle
//  init(_ constructor: @escaping (Example<T>) -> T) {
//    self.constructor = constructor
//    subject = constructor(self)
//  }
//
//  func rebuild(_ update: ((Example<T>) -> Void)? = nil) -> Example<T> {
//    let original = constructor
//
//    return Example { copy in
//      update?(copy)
//      return original(copy)
//    }
//  }
//}
//
//func stubAppComponent() -> AppComponent {
//  return AppComponent()
//    .module { InteractorModule($0) }
//    .module { ServiceModule($0) }
//    .module { SystemModule($0) }
//}
//
//func stubViewComponent() -> ViewComponent {
//  return ViewComponent()
//    .parent { stubAppComponent() }
//}
