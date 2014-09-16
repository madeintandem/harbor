//
//  ProjectTests.swift
//  Harbor
//
//  Created by Erin Hochstatter on 8/13/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

import XCTest

class ProjectTests: XCTestCase {

    //Since XCTestCase is not intended to be initialized directly from within a test case definition, shared properties initialized in setUp are declared as optional vars.(@Mattt), but Apple, in their tests calls !
    var build: Build!
    var newProject: Project!
    
    override func setUp() {

        newProject = Project(id: 10213, repositoryName: "codeship/docs")

        super.setUp()        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testProjectInit() {
        let simpleProject = Project()
        XCTAssertNotNil(simpleProject, "Should be able to create a new project")
    }
    

    
    func testForInitiallyEmptyBuildsArray(){
        XCTAssert(newProject.builds.count == 0, "There should be no projects yet")
    }
    
    func testAddingBuildToAnAccount(){
        build = Build(id: 973711, uuid: "ad4e4330-969d-0131-9581-06786cf8137c", status: "success", commitId:"96943dc5269634c211b6fbb18896ecdcbd40a047", message:"Merge pull request #34 from codeship/feature/shallow-clone", branch:"master")
        newProject.builds.append(build)
        XCTAssert(newProject.builds == [build], "The projects array should contain a project")
    }
}
