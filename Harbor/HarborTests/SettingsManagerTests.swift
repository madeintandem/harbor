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

        var subject:  SettingsManager!  = nil
        var defaults: MockUserDefaults! = nil
        
        describe("the refresh rate") {
            beforeEach {
                defaults = MockUserDefaults()
                subject  = SettingsManager(userDefaults: defaults)
            }
            
            it("updates its refresh rate") {
                let refreshRate = 60.0
                
                subject.refreshRate = refreshRate
                expect(subject.refreshRate).to(equal(60.0))
            }
            
            it("sends the user defaults the given rate"){
                let invocation  = Invocation(.SetDouble, 60.0)
                
                subject.refreshRate = invocation.value!
                expect(defaults.doubleInvocation).to(match(invocation))
            }
            
            xit("posts a notification") {
                
            }
            
        }
        
        describe("the API Key") {
            let apiKey = "9900alk00sd52fjsadlkjfsal"
            
            beforeEach {
                defaults = MockUserDefaults()
                subject  = SettingsManager(userDefaults: defaults)
            }
            
            it("updates its API Key") {
                subject.apiKey = apiKey
                expect(subject.apiKey).to(equal(apiKey))
            }
            
            xit("sets the API Key in the keychain"){
             
            }
            
            xit("posts a notification") {
                
            }
            
        }

        describe("the disabled projects array") {
            let disabledProjectIds = [3, 17, 23, 50]
            
            beforeEach {
                defaults = MockUserDefaults()
                subject  = SettingsManager(userDefaults: defaults)
            }
            
            it("updates its disabled projects") {
                subject.disabledProjectIds = disabledProjectIds
                expect(subject.disabledProjectIds).to(equal(disabledProjectIds))
            }
            
            it("sends user defaults the disabled project id array"){
                let invocation = Invocation(.SetObject, disabledProjectIds)
                
                subject.disabledProjectIds = disabledProjectIds
                expect(defaults.objectInvocation).to(match(invocation))
            }
            
            xit("posts a notification") {
                
            }
            
        }
    }
    
        //
//        describe("the 'Documentation' directory") {
//            it("has everything you need to get started") {
//                let sections = Directory("Documentation").sections
//                expect(sections).to(contain("Organized Tests with Quick Examples and Example Groups"))
//                expect(sections).to(contain("Installing Quick"))
//            }
//            
//            context("if it doesn't have what you're looking for") {
//                it("needs to be updated") {
//                    let you = You(awesome: true)
//                    expect{you.submittedAnIssue}.toEventually(beTruthy())
//                }
//            }
//        }
} }
