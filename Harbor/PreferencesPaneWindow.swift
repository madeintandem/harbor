//
//  PreferencesPaneWindow.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/10/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

import Cocoa

class PreferencesPaneWindow: NSWindowController, NSWindowDelegate {
    
    @IBOutlet var dmAccountArrayController: NSArrayController!
    var managedObjectContext: NSManagedObjectContext?

    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    @IBAction func saveButton(sender: AnyObject) {
        let errorPointer = NSErrorPointer()
        managedObjectContext?.save(errorPointer)
        
        self.window.close()
        
        let appDelegate = (NSApplication.sharedApplication()?.delegate as AppDelegate)
        appDelegate.showPopover(self)
        
    }
}
