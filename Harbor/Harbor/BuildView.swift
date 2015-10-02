//
//  BuildView.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/3/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Cocoa

class BuildView: NSView {
    
    private var model: BuildViewModel!

    @IBOutlet var view: NSView!
    @IBOutlet weak var buildMessageLabel: NSTextField!
    @IBOutlet weak var dateAndUsernameLabel: NSTextField!
    
    convenience init(model: BuildViewModel) {
        self.init(frame: NSRect(x: 0, y: 0, width: 300, height: 53))
    
        self.model = model
        self.buildMessageLabel.stringValue    = model.message()
        self.dateAndUsernameLabel.stringValue = model.authorshipInformation()
    }
    
    func didClickBuild(sender: NSMenuItem) {
        self.model.openBuildUrl()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        NSBundle.mainBundle().loadNibNamed("BuildView", owner: self, topLevelObjects: nil)
        let contentFrame = NSRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.view.frame = contentFrame
        self.addSubview(self.view)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // enables highlighting of view on mouseover
    override func drawRect(dirtyRect: NSRect) {
        let menuItem = self.enclosingMenuItem
        if menuItem?.highlighted == true {
            NSColor.blueColor().set()
            NSBezierPath.fillRect(dirtyRect)
        } else {
            super.drawRect(dirtyRect)
        }
    }
    
    // enables selecting view on mouseup
    override func mouseUp(theEvent: NSEvent) {
        let menuItem = self.enclosingMenuItem
        let menu = menuItem?.menu
        menu?.cancelTracking()
        
        let menuItemIndex = menu?.indexOfItem(menuItem!)
        menu?.performActionForItemAtIndex(menuItemIndex!)
        debugPrint(menu!.delegate)
    }
    
}

extension BuildView {
    
    class func menuItemForModel(model: BuildViewModel) -> NSMenuItem {
        let result = NSMenuItem(title: model.message(), action: "didClickBuild:", keyEquivalent: "")
        result.representedObject = model.build
        
        result.view   = BuildView(model: model)
        result.target = result.view
        
        return result
    }
    
}
