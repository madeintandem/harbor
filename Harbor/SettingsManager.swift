//
//  SettingsManager.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/24/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation
import ServiceManagement
import CoreServices

class SettingsManager {
    
    private enum Key: String, CustomStringConvertible {
        case ApiKey           = "ApiKey"
        case RefreshRate      = "RefreshRate"
        case DisabledProjects = "DisabledProjects"
        case LaunchOnLogin    = "LaunchOnLogin"
        case HasLaunched      = "HasLaunched"
        
        var description: String {
            get { return self.rawValue }
        }
        
        var storedInKeychain: Bool {
            get { return self == .ApiKey }
        }
        
        static func all() -> [Key] {
            return [ .ApiKey, .RefreshRate, .DisabledProjects, .LaunchOnLogin, .HasLaunched ]
        }
    }
    
    //
    // MARK: Dependencies
    //
   
    private let defaults:           UserDefaults
    private let keychain:           Keychain
    private let notificationCenter: NotificationCenter
    
    //
    // MARK: Properties
    //
    
    var apiKey: String {
        didSet {
            keychain.setString(apiKey, forKey: Key.ApiKey)
            self.postNotification(.ApiKey)
        }
    }
    
    var refreshRate: Double {
        didSet {
            defaults.setDouble(refreshRate, forKey: Key.RefreshRate)
            self.postNotification(.RefreshRate)
        }
    }
    
    var disabledProjectIds: [Int] {
        didSet {
            defaults.setObject(disabledProjectIds, forKey: Key.DisabledProjects)
            self.postNotification(.DisabledProjects)
        }
    }
    
    var launchOnLogin: Bool {
        didSet {
            defaults.setBool(launchOnLogin, forKey: Key.LaunchOnLogin)
            if oldValue != self.launchOnLogin {
                self.updateHelperLoginItem(self.launchOnLogin)
            }
        }
    }
   
    var isFirstRun: Bool
    
    init(
        defaults: UserDefaults = core().inject(),
        keychain: Keychain = core().inject(),
        notificationCenter: NotificationCenter = core().inject()) {
            
        self.defaults           = defaults
        self.keychain           = keychain
        self.notificationCenter = notificationCenter
       
        apiKey             = keychain.stringForKey(Key.ApiKey) ?? ""
        refreshRate        = defaults.doubleForKey(Key.RefreshRate)
        disabledProjectIds = defaults.objectForKey(Key.DisabledProjects) as? [Int] ?? [Int]()
        isFirstRun         = !defaults.boolForKey(Key.HasLaunched)
        launchOnLogin      = isFirstRun ? true : defaults.boolForKey(Key.LaunchOnLogin)
    }
    
    func startup() {
        // on first run, update the login item immediately and mark the app as launched
        if isFirstRun {
            defaults.setBool(true, forKey: Key.HasLaunched)
            self.updateHelperLoginItem(launchOnLogin) 
        }
    }
    
    func reset() {
        // clear out values for all the stored keys
        for key in Key.all() {
            if key.storedInKeychain {
                keychain.removeValueForKey(key)
            } else {
                defaults.removeValueForKey(key)
            }
        }
    }
    
    private func updateHelperLoginItem(launchOnLogin: Bool) {
        let result = SMLoginItemSetEnabled("com.dvm.Harbor.Helper", launchOnLogin)
    
        let enabled = launchOnLogin ? "enabling" : "disabling"
        let success = result ? "succeeded" : "failed"
        print("\(enabled) launch on login \(success)")
    }
    
}

//
// MARK: Notifications
//

extension SettingsManager {
    
    enum NotificationName: String {
        case ApiKey           = "ApiKey"
        case RefreshRate      = "RefreshRate"
        case DisabledProjects = "DisabledProjects"
    }
    
    func observeNotification(notification: SettingsManager.NotificationName, handler: (NSNotification -> Void)) -> NSObjectProtocol {
        return self.notificationCenter.addObserverForName(notification.rawValue, object: nil, queue: nil, usingBlock: handler)
    }
    
    private func postNotification(notification: SettingsManager.NotificationName) {
        self.notificationCenter.postNotificationName(notification.rawValue, object: nil)
    }
    
}
