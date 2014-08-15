//
//  AccountTests.swift
//  Harbor
//
//  Created by Erin Hochstatter on 8/13/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

import XCTest

class AccountTests: XCTestCase {
   
    //Since XCTestCase is not intended to be initialized directly from within a test case definition, shared properties initialized in setUp are declared as optional vars.(@Mattt), but Apple, in their tests calls !
    var newAccount: Account!
    var project: Project!
    var build: Build!
    
    override func setUp() {
        newAccount = Account()
        build = Build(id: 973711, uuid: "ad4e4330-969d-0131-9581-06786cf8137c", status: "success", commitId:"96943dc5269634c211b6fbb18896ecdcbd40a047", message:"Merge pull request #34 from codeship/feature/shallow-clone", branch:"master")
        project = Project(id: 10213, repositoryName: "codeship/docs", builds: [build])
        
        super.setUp()
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        super.tearDown()
    }
    
    func testAccountInit() {
        let simpleAccount = Account()
        XCTAssertNotNil(simpleAccount, "Should be able to create a new account")
    }
    

    func testForInitiallyEmptyProjectArray(){
        XCTAssertEqual(newAccount.projects.count, 0, "There should be no projects yet")
    }

    func testAddingProjectsToAnAccount(){
        newAccount.projects.append(project)
        XCTAssertEqualObjects(newAccount.projects, [project], "The projects array should contain a project")
    }
}
