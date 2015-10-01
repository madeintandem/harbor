//
//  ProjectsProviderTests.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/28/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Quick
import Nimble
@testable import Harbor

class ProjectsProviderTests : HarborSpec { override func spec() {
    super.spec()
 
    var example:  Example<ProjectsProvider>!
    var projects: [Project]?
    
    beforeEach {
        example = Example(constructor: {
            return ProjectsProvider()
        })
        
        example.subject.addHandler { local in
            projects = local
        }
    }
    
    describe("refreshing projects") {
        
        beforeEach {
            example.codeshipApi.mockProjects()
            example.subject.refreshProjects()
        }
        
        it("refreshes all projects") {
            expect(projects).to(equal(example.codeshipApi.projects!))
        }
        
        it("updates the disabled projects when the disabledProjectIds change") {
            let disabledIds = [0]
            
            example.settings.disabledProjectIds = disabledIds
            example.subject.refreshCurrentProjects()
            
            expect(projects).to(allPass { project in
                return !disabledIds.contains(project!.id) == project!.isEnabled
            })
        }
        
    }
    
    describe("when a listener is added"){
        it("calls the listener back immediately with the current projects") {
            let projects = [ Project(id: 5) ]
            
            example.codeshipApi.projects = projects
            example.subject.refreshProjects()
            
            example.subject.addHandler { local in
                expect(local).to(equal(projects))
            }
        }
    }
} }
