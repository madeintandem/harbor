//
//  ProjectMenuItem.swift
//  Harbor
//
//  Created by Ty Cobb on 10/2/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Cocoa

class ProjectMenuItem : NSMenuItem {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
  
    init(model: ProjectMenuItemModel) {
        super.init(title: model.title, action: nil, keyEquivalent: "")
        
        self.image   = model.status.icon()
        self.submenu = self.submenuForModel(model)
    }
    
    func submenuForModel(model: ProjectMenuItemModel) -> NSMenu {
        let menu = NSMenu(title: model.submenuTitle)
        for build in model.builds() {
            menu.addItem(BuildView.menuItemForModel(build))
        }
        
        return menu
    }
    
}
