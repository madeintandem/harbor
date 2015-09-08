//
//  PreferencesPaneWindowController.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/8/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Cocoa

class PreferencesPaneWindowController: NSWindowController, NSWindowDelegate, NSTextFieldDelegate {

    @IBOutlet weak var codeshipAPIKey: NSTextField!
    
    @IBAction func saveButton(sender: AnyObject) {
        KeychainWrapper.setString(codeshipAPIKey.stringValue, forKey: "APIKey")
        CodeshipApi.getProjects(handleGetProjectsRequest, errorHandler: handleGetProjectsError)
        self.close()
        
    }

    func handleGetProjectsRequest(result: [Project]){
        (NSApplication.sharedApplication().delegate as! AppDelegate).handleGetProjectsRequest(result)
    }
    
    func handleGetProjectsError(error: String){
        //this is only a JSON Parsing error.  A fetch error needs separate handling.
        debugPrint(error)
    }
    
    
    override func windowDidLoad() {
        super.windowDidLoad()
        if let token = KeychainWrapper.stringForKey("APIKey"){
            codeshipAPIKey.stringValue = token as String
        }
    }

}
