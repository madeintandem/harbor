import Cocoa

protocol StatusMenuDelegate: NSMenuDelegate {
  func statusMenuDidSelectPreferences(_ statusMenu: StatusMenu)
}

class StatusMenu: NSMenu, StatusMenuView {
  //
  // MARK: Dependencies
  fileprivate var component = ViewComponent()
    .parent { Application.component() }
    .module { StatusMenuModule($0) }

  fileprivate lazy var presenter: StatusMenuPresenter<StatusMenu> = self.component.status.inject(self)

  //
  // MARK: Properties
  fileprivate let fixedMenuItemCount = 3
  fileprivate let statusBarItem      = NSStatusBar.system().statusItem(withLength: -1) // NSVariableStatusItemLength

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    if Environment.active != .testing {
      presenter.didInitialize()
    }
  }

  //
  // MARK: StatusMenuView
  func createCoreMenuItems() {
    statusBarItem.menu = self

    let preferences    = item(at: 1)!
    preferences.target = self
    preferences.action = #selector(StatusMenu.didClickPreferencesItem)
  }

  func updateBuildStatus(_ status: Build.Status) {
    statusBarItem.image = status.icon()
  }

  func updateProjects(_ projects: [ProjectMenuItemModel]) {
    // clear stale projects, if any, from menu
    let range = fixedMenuItemCount..<items.count
    for index in range.reversed() {
      removeItem(at: index)
    }

    // add the separator between fixed items and projects
    let separatorItem = NSMenuItem.separator()
    addItem(separatorItem)

    // add each project
    for project in projects {
      addItem(ProjectMenuItem(model: project))
    }
  }

  //
  // MARK: Interface Actions
  func didClickPreferencesItem() {
    statusMenuDelegate.statusMenuDidSelectPreferences(self)
  }

  //
  // MARK: Custom Delegate
  var statusMenuDelegate: StatusMenuDelegate {
    get { return delegate as! StatusMenuDelegate }
    set { delegate = newValue }
  }
}
