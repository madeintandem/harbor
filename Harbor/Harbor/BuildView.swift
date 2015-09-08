//
//  BuildView.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/3/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Cocoa

class BuildView: NSView {

    @IBOutlet var view: NSView!
    @IBOutlet weak var buildMessageLabel: NSTextField!
    @IBOutlet weak var dateAndUsernameLabel: NSTextField!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        NSBundle.mainBundle().loadNibNamed("BuildView", owner: self, topLevelObjects: nil)
        let contentFrame = NSRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.view.frame = contentFrame
        self.addSubview(self.view)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        NSBundle.mainBundle().loadNibNamed("BuildView", owner: nil, topLevelObjects: nil)
        let contentFrame = NSRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.view.frame = contentFrame
        self.addSubview(self.view)
    }
    
    // enables highlighting of view on mouseover
    override func drawRect(dirtyRect: NSRect) {
        let menuItem = self.enclosingMenuItem
//        debugPrint(menuItem)
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
