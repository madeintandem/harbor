//
//  AppDelegate.swift
//  HarborHelper
//
//  Created by Ty Cobb on 10/5/15.
//  Copyright © 2015 Devmynd. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let app = NSWorkspace.shared().runningApplications.find { app in
      return app.bundleIdentifier == "com.dvm.Harbor"
    }

    // if the app isn't running, then let's start it
    if app == nil || !app!.isActive {
      let path = self.applicationPath()
      NSWorkspace.shared().launchApplication(path)
    }

    // kill the helper app
    NSApp.terminate(nil)
  }

  fileprivate func applicationPath() -> String {
    var components = Bundle.main.bundlePath.components(separatedBy: "/")

    // helper is at "Library/LoginItems/HarborHelper" relative to the app root
    components.removeSubrange(components.count-3..<components.count)
    // and the main app is at "MacOS/Harbor"
    components.append(contentsOf: ["MacOS", "Harbor"])

    return components.joined(separator: "/")
  }
}

extension Sequence {
  func find(_ predicate: (Iterator.Element) -> Bool) -> Iterator.Element? {
    return self.filter(predicate).first
  }
}
