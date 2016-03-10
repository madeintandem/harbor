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

class PreferencesPresenterTests : HarborSpec { override func spec() {
    super.spec()
    
    var subject: PreferencesPresenter<MockPreferencesView>!
    var view: MockPreferencesView!
    var projectsInteractor: MockProjectsProvider!
    
    beforeEach{
        view    = MockPreferencesView()
        subject = PreferencesPresenter(view: view)
        projectsInteractor = (core().inject() as ProjectsInteractor) as! MockProjectsProvider
    }
    
    describe("presentation cycle"){
        
        it("listens to the projectsProvider") {
            let invocation = Invocations.projectsInteractor(.AddListener, VerifierOf(None.Nothing))
            
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
        
        it("refreshes the view when it disappears") {
            subject.setNeedsRefresh()
            expect(subject.needsRefresh).to(beTrue())
            
            subject.didResignActive()
            expect(subject.needsRefresh).to(beFalse())
        }
        
        xit("updates the view when refreshing") {
            let invocation = Invocations.preferencesView(.UpdateApiKey, VerifierOf("asdf"))
            expect(subject.view.invocations).to(haveAnyMatch(invocation))
        }
    }
    
} }