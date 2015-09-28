//
//  SettingsManagerTests.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/25/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Quick
import Nimble
import Harbor

class SettingsManagerTests: QuickSpec { override func spec() {

    describe("Properties") {

        var subject:            SettingsManager!  = nil
        var defaults:           MockUserDefaults! = nil
        var keychain:           MockKeychain! = nil
        var notificationCenter: MockNotificationCenter! = nil
        
        let buildSettingsManager = {
            defaults = MockUserDefaults()
            keychain = MockKeychain()
            notificationCenter = MockNotificationCenter()
            subject  = SettingsManager(userDefaults: defaults, keychain: keychain, notificationCenter: notificationCenter)
        }
        
        let notificationInvocation = { (method: MockNotificationCenter.Method, name: SettingsManager.NotificationName) in
            return Invocation(method, name.rawValue)
        }
        
        describe("the refresh rate") {
            beforeEach {
                buildSettingsManager()
            }
            
            it("updates its refresh rate") {
                let refreshRate = 60.0
                
                subject.refreshRate = refreshRate
                expect(subject.refreshRate).to(equal(60.0))
            }
            
            it("sends the user defaults the given rate"){
                let invocation  = Invocation(MockUserDefaults.Method.SetDouble, 60.0)
                
                subject.refreshRate = invocation.value!
                expect(defaults.doubleInvocation).to(match(invocation))
            }
            
            it("posts a notification") {
                let invocation = notificationInvocation(.PostNotificationName, .RefreshRate)
                
                subject.refreshRate = 60.0
                expect(notificationCenter.invocation).to(match(invocation))
            }
            
        }
        
        describe("the API Key") {
            let apiKey = "9900alk00sd52fjsadlkjfsal"
            
            beforeEach {
                buildSettingsManager()
            }
            
            it("updates its API Key") {
                subject.apiKey = apiKey
                expect(subject.apiKey).to(equal(apiKey))
            }
            
            it("sets the API Key in the keychain"){
                let invocation = Invocation(MockKeychain.Method.SetString, apiKey)
                
                subject.apiKey = apiKey
                expect(keychain.invocation).to(match(invocation))
            }
            
            it("posts a notification") {
                let invocation = notificationInvocation(.PostNotificationName, .ApiKey)
                
                subject.apiKey = apiKey
                expect(notificationCenter.invocation).to(match(invocation))
            }
            
        }

        describe("the disabled projects array") {
            let disabledProjectIds = [3, 17, 23, 50]
            
            beforeEach {
                buildSettingsManager()
            }
            
            it("updates its disabled projects") {
                subject.disabledProjectIds = disabledProjectIds
                expect(subject.disabledProjectIds).to(equal(disabledProjectIds))
            }
            
            it("sends user defaults the disabled project id array"){
                let invocation = Invocation(MockUserDefaults.Method.SetObject, disabledProjectIds)
                
                subject.disabledProjectIds = disabledProjectIds
                expect(defaults.objectInvocation).to(match(invocation))
            }
            
            it("posts a notification") {
                let invocation = notificationInvocation(.PostNotificationName, .DisabledProjects)
                
                subject.disabledProjectIds = disabledProjectIds
                expect(notificationCenter.invocation).to(match(invocation))
            }
            
        }
    }    
} }
