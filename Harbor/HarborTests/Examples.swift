//
//  Examples.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/28/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Harbor

struct SettingsManagerExample {
    
    let subject:  SettingsManager
    let keychain: MockKeychain
    let defaults: MockUserDefaults
    let notificationCenter: MockNotificationCenter

    init(_ example: SettingsManagerExample? = nil) {
        self.defaults = example != nil ? example!.defaults : MockUserDefaults()
        self.keychain = example != nil ? example!.keychain : MockKeychain()
        self.notificationCenter = example != nil ? example!.notificationCenter : MockNotificationCenter()
        self.subject = SettingsManager(userDefaults: defaults, keychain: keychain, notificationCenter: notificationCenter)
    }
    
    func rebuild() -> SettingsManagerExample {
        return SettingsManagerExample(self)
    }
    
}

struct TimerCoordinatorExample {
    
    let subject:           TimerCoordinator
    let settingsManager:   SettingsManager
    let projectsProvider:  ProjectsProvider
    let notifcationCenter: MockNotificationCenter
    let runLoop:           MockRunLoop
    
    init() {
        let settingsExample = SettingsManagerExample()
        
        self.settingsManager   = settingsExample.subject
        self.notifcationCenter = settingsExample.notificationCenter
        
        self.projectsProvider = ProjectsProvider.instance
        self.runLoop = MockRunLoop()
        
        self.subject = TimerCoordinator(runLoop: runLoop, projectsProvider: projectsProvider, settingsManager: settingsManager)
    }
    
}
