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
        let isRunning = NSWorkspace.sharedWorkspace().runningApplications.contains { app in
            return app.bundleIdentifier == "com.devymnd.Harbor.Harbor"
        }
       
        // if the app isn't running, then let's start it
        if !isRunning {
            let path = self.applicationPath()
            NSWorkspace.sharedWorkspace().launchApplication(path)
        }
       
        // kill the helper app
        NSApp.terminate(nil)
    }
    
    private func applicationPath() -> String {
        let components = NSBundle.mainBundle().bundlePath.componentsSeparatedByString("/")
        let subcomponents = components[0...components.count-3]
        return subcomponents.joinWithSeparator("/")
    }

}

