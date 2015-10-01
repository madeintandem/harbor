//
//  MockCoreModule.swift
//  Harbor
//
//  Created by Ty Cobb on 10/1/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

@testable import Harbor

struct MockCoreModule : CoreModuleType {
    
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
        return single { MockCodeshipApi() }
    }
    
    //
    // Foundation
    //
    
    func inject() -> UserDefaults {
        return single { MockUserDefaults() }
    }
    
    func inject() -> NotificationCenter {
        return single { MockNotificationCenter() }
    }
    
    func inject() -> RunLoop {
        return single { MockRunLoop() }
    }
    
    //
    // Utilities
    //
    
    func inject() -> Keychain {
        return single { MockKeychain() }
    }
    
}