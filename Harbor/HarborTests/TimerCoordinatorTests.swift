//
//  TimerCoordinatorTests.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/28/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Quick
import Nimble
import Harbor
import Foundation

class TimerCoordinatorTests : QuickSpec { override func spec() {
    
    var example: TimerCoordinatorExample!

    beforeEach {
        example = TimerCoordinatorExample()
    }
    
    it("the initializer observes the settings manager notification"){
        let invocation = notificationInvocation(.AddObserverForName, .RefreshRate)
        expect(example.notifcationCenter.invocation).to(match(invocation))
    }
    
    describe("when starting a timer") {
        
        beforeEach {
            example.settingsManager.refreshRate = 60.0
        }
        
        it("should not create a timer when the refresh rate is 0.0") {
            example.settingsManager.refreshRate = 0.0
            
            let timer = example.subject.startTimer()
            expect(timer).to(beNil())
        }
        
        it("creates a timer") {
            let timer = example.subject.startTimer()
            expect(timer).toNot(beNil())
            expect(timer!.timeInterval).to(equal(example.settingsManager.refreshRate))
        }
        
        it("adds the timer to the run loop") {
            let timer = example.subject.startTimer()
            let invocation = Invocation(MockRunLoop.Method.AddTimer, timer)
            
            expect(example.runLoop.invocation).to(match(invocation))
        }
        
        context("when there's an existing timer") {
            
            it("cancels the existing timer") {
                let existingTimer = example.subject.startTimer()
                let currentTimer = example.subject.startTimer()
                
                expect(existingTimer?.valid).to(beFalse())
                expect(existingTimer).toNot(equal(currentTimer))
            }
            
        }
        
    }
} }