import Cocoa

protocol StatusMenuDelegate: NSMenuDelegate {
  func statusMenuDidSelectPreferences(statusMenu: StatusMenu)
}

class StatusMenu: NSMenu, StatusMenuView {
  //
  // MARK: Dependencies
  private var component = ViewComponent()
    .parent { Application.component() }
    .module(StatusMenuModule.self) { StatusMenuModule($0) }

  private lazy var presenter: StatusMenuPresenter<StatusMenu> = self.component.status.inject(self)

  //
  // MARK: Properties
  private let fixedMenuItemCount = 3
  private let statusBarItem      = NSStatusBar.systemStatusBar().statusItemWithLength(-1) // NSVariableStatusItemLength

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    if Environment.active != .Testing {
      presenter.didInitialize()
    }
  }

  //
  // MARK: StatusMenuView
  func createCoreMenuItems() {
    statusBarItem.menu = self

    let preferences    = itemAtIndex(1)!
    preferences.target = self
    preferences.action = Selector("didClickPreferencesItem")
  }

  func updateBuildStatus(status: BuildStatus) {
    statusBarItem.image = status.icon()
  }

  func updateProjects(projects: [ProjectMenuItemModel]) {
    // clear stale projects, if any, from menu
    let range = fixedMenuItemCount..<itemArray.count
    for index in range.reverse() {
      removeItemAtIndex(index)
    }

    // add the separator between fixed items and projects
    let separatorItem = NSMenuItem.separatorItem()
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