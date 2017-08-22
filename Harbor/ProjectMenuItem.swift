import Cocoa

class ProjectMenuItem : NSMenuItem {
  required init(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(model: ProjectMenuItemModel) {
    super.init(title: model.title, action: nil, keyEquivalent: "")

    self.image   = model.status.icon()
    self.submenu = self.submenuForModel(model)
  }

  func submenuForModel(_ model: ProjectMenuItemModel) -> NSMenu {
    let menu = NSMenu(title: model.submenuTitle)
    for build in model.builds() {
      menu.addItem(BuildView.menuItemForModel(build))
    }

    return menu
  }
}
