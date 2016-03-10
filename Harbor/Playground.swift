//
//  Playground.swift
//  Harbor
//
//  Created by Erin Hochstatter on 7/16/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation

class Playground {
    
    func writeFile(text: String) -> Bool {
        
        do {
            let tempURL = NSURL(string: "file:///tmp/holyfuckingshit.txt")
            try text.writeToURL(tempURL!, atomically: true, encoding: NSUTF8StringEncoding)
            return true
        } catch {
            print("Failed to write file")
            return false
        }
    }
    
    func readFromFile(fileName: String) throws -> String {
//        let path = NSBundle.mainBundle().bundleURL
//        let fileURL = path.URLByAppendingPathComponent(fileName);
        let fileURL = NSURL(string: fileName);
        return try String(contentsOfURL: fileURL!)
    }
}

