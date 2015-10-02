//
//  AppDelegate.swift
//  Harbor
//
//  Created by Erin Hochstatter on 6/25/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Cocoa
import Alamofire

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    @IBOutlet weak var statusItemMenu: StatusMenu!
    let preferencesWindowController = PreferencesPaneWindowController(windowNibName: "PreferencesPaneWindowController")
    var projects: [Project]?
    let defaults = NSUserDefaults()
    
    let projectsProvider = ProjectsProvider.instance
    let timerCoordinator = TimerCoordinator.instance
    let settingsManager  = SettingsManager.instance
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
//
//        Uncomment to Clear keychain & Defaults for testing.
//
//        KeychainWrapper.removeObjectForKey("ApiKey")
//        defaults.removeObjectForKey("RefreshRate")
//        defaults.removeObjectForKey("DisabledProjects")

        statusItemMenu.delegate = self
        statusItemMenu.itemAtIndex(1)?.action = Selector("showPreferencesPane")
        statusItemMenu.formatMenu([])
    
        self.refreshProjects()
        self.timerCoordinator.startTimer()
    }
    
    func refreshProjects() {
        if !settingsManager.apiKey.isEmpty {
            self.projectsProvider.refreshProjects()
        } else {
            self.showPreferencesPane()
        }
    }
    
    func showPreferencesPane(){
        preferencesWindowController.window?.center()
        preferencesWindowController.window?.orderFront(self)
        
        // Show your window in front of all other apps
        NSApp.activateIgnoringOtherApps(true)
        
    }
        
}

