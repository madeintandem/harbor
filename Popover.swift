//
//  Popover.swift
//  Harbor
//
//  Created by Erin Hochstatter on 8/16/14.
//  Copyright (c) 2014 devMynd. All rights reserved.
//

import Cocoa

class Popover: NSViewController {
    
    @IBOutlet weak var codeshipApiTextField: NSTextField!
    
    @IBOutlet weak var projectsTableView: NSScrollView!
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
 
    override init() {
        super.init(nibName: "Popover", bundle: nil)
    }
}