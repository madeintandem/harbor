//
//  Example.swift
//  Harbor
//
//  Created by Ty Cobb on 10/1/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

@testable import Harbor

struct Example<T> {

    private let constructor: () -> T
    
    let subject: T
    let runLoop: MockRunLoop
    let keychain: MockKeychain
    let defaults: MockUserDefaults
    let settings: SettingsManager
    let codeshipApi: MockCodeshipApi
    let notificationCenter: MockNotificationCenter
    
    init(constructor: () -> T) {
        self.constructor = constructor
        
        self.subject     = constructor()
        self.runLoop     = (core().inject() as RunLoop) as! MockRunLoop
        self.keychain    = (core().inject() as Keychain) as! MockKeychain
        self.defaults    = (core().inject() as UserDefaults) as! MockUserDefaults
        self.settings    = (core().inject())
        self.codeshipApi = (core().inject() as CodeshipApiType) as! MockCodeshipApi
        self.notificationCenter = (core().inject() as NotificationCenter) as! MockNotificationCenter
    }
    
    func rebuild() -> Example<T> {
        return Example(constructor: self.constructor)
    }
    
}
