
import AppKit

@objc(Application)
class Application: NSApplication {
  // MARK: Dependencies
  private let _component = AppComponent()
    .module { InteractorModule($0) }
    .module { ServiceModule($0) }
    .module { SystemModule($0) }

  class func component() -> AppComponent {
    return (NSApp as! Application)._component
  }
}
