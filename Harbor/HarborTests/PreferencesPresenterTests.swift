//
//  PreferencesPresenterTests.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/29/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Quick
import Nimble
@testable import Harbor

class PreferencesPresenterTests : QuickSpec { override func spec() {

    var subject: PreferencesPresenter!
    var view: MockPreferencesView!
    var projectsInteractor: MockProjectsProvider!
    var settingsManager: SettingsManager!
    
    beforeEach{
        view               = MockPreferencesView()
        projectsInteractor = MockProjectsProvider()
        settingsManager    = SettingsManagerExample().subject
        
        subject = PreferencesPresenter(
            view: view,
            projectsInteractor: projectsInteractor,
            settingsManager: settingsManager
        )
    }
    
    describe("presentation cycle"){
        it("listens to the projectsProvider"){
            let invocation = Invocation<MockProjectsProvider.Method, None>(.AddHandler, .Nothing)
            
            subject.didInitialize()
            expect(projectsInteractor.invocation).to(match(invocation))
        }
        
        it("sets the needsRefresh flag properly") {
            subject.setNeedsRefresh()
            expect(subject.needsRefresh).to(beTrue())
        }
        
        it("refreshes the view when it appears") {
            subject.setNeedsRefresh()
            expect(subject.needsRefresh).to(beTrue())
            
            subject.didBecomeActive()
            expect(subject.needsRefresh).to(beFalse())
        }
        
        it("refreshes the view when it disappears"){
            subject.setNeedsRefresh()
            expect(subject.needsRefresh).to(beTrue())
            
            subject.didResignActive()
            expect(subject.needsRefresh).to(beFalse())
        }
        
        it("updates the view when refreshing"){
            let invocation = Invocation<MockPreferencesView.Method, String>(.UpdateApiKey, "")
            
            subject.setNeedsRefresh()
            subject.didBecomeActive()
            
            let matcher: NonNilMatcherFunc<Invocation<MockPreferencesView.Method, String>> = matchInvocation(invocation)
            
//            expect(view.invocations).to(haveAny(match(invocation)))
        }
    }
    
    describe("preferences"){
        
    }
    
} }