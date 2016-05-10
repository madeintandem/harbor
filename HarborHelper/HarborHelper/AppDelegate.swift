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
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    let app = NSWorkspace.sharedWorkspace().runningApplications.find { app in
      return app.bundleIdentifier == "com.dvm.Harbor"
    }

    // if the app isn't running, then let's start it
    if app == nil || !app!.active {
      let path = self.applicationPath()
      NSWorkspace.sharedWorkspace().launchApplication(path)
    }

    // kill the helper app
    NSApp.terminate(nil)
  }

  private func applicationPath() -> String {
    var components = NSBundle.mainBundle().bundlePath.componentsSeparatedByString("/")

    // helper is at "Library/LoginItems/HarborHelper" relative to the app root
    components.removeRange(components.count-3..<components.count)
    // and the main app is at "MacOS/Harbor"
    components.appendContentsOf(["MacOS", "Harbor"])

    return components.joinWithSeparator("/")
  }
}

extension SequenceType {
  func find(predicate: (Generator.Element) -> Bool) -> Generator.Element? {
    return self.filter(predicate).first
  }
}
