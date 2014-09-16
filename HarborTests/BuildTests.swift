//
//  BuildTests.swift
//  Harbor
//
//  Created by Erin Hochstatter on 8/13/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

import XCTest

class BuildTests: XCTestCase {

    //Since XCTestCase is not intended to be initialized directly from within a test case definition, shared properties initialized in setUp are declared as optional vars.(@Mattt), but Apple, in their tests calls !
    var newBuild: Build!
    
    override func setUp() {
        
        newBuild = Build(id: 973711, uuid: "ad4e4330-969d-0131-9581-06786cf8137c", status: "success", commitId:"96943dc5269634c211b6fbb18896ecdcbd40a047", message:"Merge pull request #34 from codeship/feature/shallow-clone", branch:"master")
        
        super.setUp()        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBuildInit() {
        let simpleBuild = Project()
        XCTAssertNotNil(simpleBuild, "Should be able to create a new build")
    }
    
    func testThatBuildHasAnId(){
        XCTAssert(newBuild.id == 973711, "The id should match the value assigned")
    }
    
    func testThatBuildHasAnUuid(){
        XCTAssert(newBuild.uuid == "ad4e4330-969d-0131-9581-06786cf8137c", "The UUID should match the value assigned")
    }
    
}
