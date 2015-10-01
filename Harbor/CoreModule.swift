//
//  Injections.swift
//  Harbor
//
//  Created by Ty Cobb on 10/1/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation

struct CoreModule : CoreModuleType {
   
    //
    // Interactors
    //
    
    func inject() -> SettingsManager {
        return single { SettingsManager() }
    }
    
    func inject() -> ProjectsProvider {
        return single { ProjectsProvider() }
    }
    
    func inject() -> TimerCoordinator {
        return single { TimerCoordinator() }
    }
    
    //
    // Services
    //

    func inject() -> CodeshipApiType {
        return transient { CodeshipApi() }
    }
    
    //
    // Foundation
    //
    
    func inject() -> UserDefaults {
        return transient { NSUserDefaults.standardUserDefaults() }
    }
    
    func inject() -> NotificationCenter {
        return transient { NSNotificationCenter.defaultCenter() }
    }
    
    func inject() -> RunLoop {
        return transient { NSRunLoop.mainRunLoop() }
    }
    
    //
    // Utilities
    //
    
    func inject() -> Keychain {
        return transient { KeychainWrapper() }
    }
    
}
