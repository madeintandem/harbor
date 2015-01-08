//
//  PreferencesPaneWindow.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/10/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

import Cocoa

class PreferencesPaneWindow: NSWindowController, NSWindowDelegate {

    var prefManagedObjectContext: NSManagedObjectContext?
    
    @IBOutlet var dmProjectArrayController: NSArrayController!
    @IBOutlet var dmAccountArrayController: NSArrayController!
    
    @IBOutlet weak var accountNameLabel: NSTextField!
    @IBOutlet weak var apiKeyLabel: NSTextField!
    @IBOutlet weak var refreshRateLabel: NSTextField!
    @IBOutlet weak var projectColumn: NSTableColumn!
    @IBOutlet weak var followColumn: NSTableColumn!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        var bariolBold: NSFont = NSFont (name: "Bariol-Bold", size: 15)!
        accountNameLabel.font = bariolBold
        apiKeyLabel.font = bariolBold
        refreshRateLabel.font = bariolBold

    }
    
    func windowWillClose(notification: NSNotification!) {
        let appDelegate = (NSApplication.sharedApplication().delegate as AppDelegate)
        appDelegate.showPopover(self)
    }

    @IBAction func saveButton(sender: AnyObject) {
        let errorPointer = NSErrorPointer()
        prefManagedObjectContext?.save(errorPointer)
        
        self.close()
    }
}
