//
//  PreferencesPaneWindowController.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/8/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Cocoa

class PreferencesPaneWindowController: NSWindowController, NSWindowDelegate {

    @IBOutlet weak var codeshipAPIKey: NSTextField!
    
    @IBAction func saveButton(sender: AnyObject) {
    }
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
