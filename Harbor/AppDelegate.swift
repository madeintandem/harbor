
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, StatusMenuDelegate {
  //
  // MARK: Dependencies
  fileprivate lazy var settings: SettingsType = Settings.instance
  fileprivate lazy var projectsInteractor: ProjectsInteractor = ProjectsProvider.instance
  fileprivate lazy var timerCoordinator: TimerCoordinatorType = TimerCoordinator.instance

  //
  // MARK: Interface Elements
  @IBOutlet weak var statusItemMenu: StatusMenu!
  var preferencesWindowController: PreferencesPaneWindowController!

  //
  // MARK: NSApplicationDelegate
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if Environment.active == .testing {
      return
    }

    preferencesWindowController = PreferencesPaneWindowController(windowNibName: "PreferencesPaneWindowController")
    statusItemMenu.statusMenuDelegate = self

    // run startup logic
    startup()
  }

  //
  // MARK: Startup
  fileprivate func startup() {
    settings.startup()
    timerCoordinator.startup()

    refreshProjects()
  }

  fileprivate func refreshProjects() {
    if !settings.apiKey.isEmpty {
      projectsInteractor.refreshProjects()
    } else {
      showPreferencesPane()
    }
  }

  //
  // MARK: StatusMenuDelegate
  func statusMenuDidSelectPreferences(_ statusMenu: StatusMenu) {
    showPreferencesPane()
  }

  fileprivate func showPreferencesPane() {
    preferencesWindowController.window?.center()
    preferencesWindowController.window?.orderFront(self)

    // Show your window in front of all other apps
    NSApp.activate(ignoringOtherApps: true)
  }
}
