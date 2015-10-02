//
//  CoreModuleType.swift
//  Harbor
//
//  Created by Ty Cobb on 10/1/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation

// top-level function to access injections
func core() -> CoreModuleType {
    return Injector.module()
}

protocol CoreModuleType : Module {
    // foundation facades
    func inject() -> UserDefaults
    func inject() -> NotificationCenter
    func inject() -> RunLoop
    
    // interactors
    func inject() -> TimerCoordinator
    func inject() -> ProjectsInteractor
    func inject() -> SettingsManager
    
    // services
    func inject() -> CodeshipApiType
    
    // utilities
    func inject() -> Keychain
}
