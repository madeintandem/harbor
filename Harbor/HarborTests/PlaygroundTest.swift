//
//  PlaygroundTest.swift
//  Harbor
//
//  Created by Erin Hochstatter on 7/16/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation
import XCTest

class PlaygroundTests: XCTestCase {
    let playground = Playground()
    
    func testWriteFile() {
        let writeFileResult = playground.writeFile("The text in file")
        assert(writeFileResult, "Write file returned true.")
    }
    
    func testReadFromFile() {
        do {
         let readFileResult = try playground.readFromFile("file:/Users/erinhochstatter/Documents/DevMynd/swiftHarbor/Harbor/Harbor/Harbor/word.txt")
            print(readFileResult)
            assert("cameo" == readFileResult, "Word up")
        } catch {
            assert(false, "Noooooooope")
        }
    }
}