//
//  SettingsManager.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/24/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation

class SettingsManager {
    
    private enum Key: String {
        case ApiKey             =   "ApiKey"
        case RefreshRate        =   "RefreshRate"
        case DisabledProjects   =   "DisabledProjects"
    }

    static let instance = SettingsManager()

    //
    // MARK: Properties
    //
    
    private var defaults: NSUserDefaults
    
    var apiKey: String {
        didSet {
            KeychainWrapper.setString(self.apiKey, forKey: Key.ApiKey.rawValue)
            self.postNotification(.ApiKey)
        }
    }
    
    var refreshRate: Double {
        didSet {
            self.defaults.setDouble(self.refreshRate, forKey: Key.RefreshRate.rawValue)
            self.postNotification(.RefreshRate)
        }
    }
    
    var disabledProjectIds: [Int] {
        didSet {
            self.defaults.setObject(self.disabledProjectIds, forKey: Key.DisabledProjects.rawValue)
            self.postNotification(.DisabledProjects)
        }
    }
    
    private init() {
        self.defaults    = NSUserDefaults.standardUserDefaults()
        self.refreshRate = self.defaults.doubleForKey(Key.RefreshRate.rawValue)
        
        if let disabledProjectIds = self.defaults.objectForKey(Key.DisabledProjects.rawValue) as? [Int]{
            self.disabledProjectIds = disabledProjectIds
        } else {
            self.disabledProjectIds = [Int]()
        }
        
        if let apiKey = KeychainWrapper.stringForKey(Key.ApiKey.rawValue) {
            self.apiKey = apiKey
        } else {
            self.apiKey = ""
        }
    }
    
}

//
// MARK: Notifications
//

extension SettingsManager {
    
    internal enum NotificationName: String {
        case ApiKey             =   "ApiKey"
        case RefreshRate        =   "RefreshRate"
        case DisabledProjects   =   "DisabledProjects"
    }
    
    func observeNotification(notification: SettingsManager.NotificationName, handler: (NSNotification -> Void)) -> NSObjectProtocol {
        return NSNotificationCenter.defaultCenter().addObserverForName(notification.rawValue, object: nil, queue: nil, usingBlock: handler)
    }
    
    private func postNotification(notification: SettingsManager.NotificationName) {
        NSNotificationCenter.defaultCenter().postNotificationName(notification.rawValue, object: nil)
    }
    
}
