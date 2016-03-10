//
//  MockPreferencesView.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/29/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

@testable import Harbor

class MockPreferencesView : PreferencesView {
    
    enum Method : MethodType {
        case UpdateProjects
        case UpdateRefreshRate
        case UpdateApiKey
    }
 
    var invocations: [Invocation<Method>]
 
    init() {
        self.invocations = [Invocation<Method>]()
    }
    
    func updateProjects(projects: [Project]) {
        self.invocations.append(Invocation(.UpdateProjects, projects))
    }
    
    func updateRefreshRate(refreshRate: String) {
        self.invocations.append(Invocation(.UpdateRefreshRate, refreshRate))
    }
    
    func updateApiKey(apiKey: String) {
        self.invocations.append(Invocation(.UpdateApiKey, apiKey))
    }
    
    func updateLaunchOnLogin(launchOnLogin: Bool) {
        
    }
    
}

extension Invocations {
    static func preferencesView<E: Verifiable>(method: MockPreferencesView.Method, _ value: E) -> ExpectedInvocation<MockPreferencesView.Method, E> {
        return ExpectedInvocation(method, value)
    }
}
