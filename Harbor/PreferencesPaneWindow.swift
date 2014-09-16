//
//  PreferencesPaneWindow.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/10/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

import Cocoa

class PreferencesPaneWindow: NSWindowController, NSWindowDelegate {
    
    var managedObjectContext: NSManagedObjectContext?
    var apiKey: String?

    override func windowDidLoad() {
        super.windowDidLoad()
    }
      
    override func close(){
        println("closed")
    }
}
