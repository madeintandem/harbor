
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, StatusMenuDelegate {
  //
  // MARK: Dependencies
  var component: AppComponent { return Application.component() }

  private lazy var settings:           Settings           = self.component.interactor.inject()
  private lazy var projectsInteractor: ProjectsInteractor = self.component.interactor.inject()
  private lazy var timerCoordinator:   TimerCoordinator   = self.component.interactor.inject()

  //
  // MARK: Interface Elements
  @IBOutlet weak var statusItemMenu: StatusMenu!
  var preferencesWindowController: PreferencesPaneWindowController!

  //
  // MARK: NSApplicationDelegate
  func applicationDidFinishLaunching(aNotification: NSNotification) {
    if Environment.active == .Testing {
      return
    }

    preferencesWindowController = PreferencesPaneWindowController(windowNibName: "PreferencesPaneWindowController")
    statusItemMenu.statusMenuDelegate = self

    // run startup logic
    startup()
  }

  //
  // MARK: Startup
  private func startup() {
    settings.startup()
    timerCoordinator.startup()

    refreshProjects()
  }

  private func refreshProjects() {
    if !settings.apiKey.isEmpty {
      projectsInteractor.refreshProjects()
    } else {
      showPreferencesPane()
    }
  }

  //
  // MARK: StatusMenuDelegate
  func statusMenuDidSelectPreferences(statusMenu: StatusMenu) {
    showPreferencesPane()
  }

  private func showPreferencesPane() {
    preferencesWindowController.window?.center()
    preferencesWindowController.window?.orderFront(self)
    preferencesWindowController.window?.title = "Harbor Preferences"

    // Show your window in front of all other apps
    NSApp.activateIgnoringOtherApps(true)
  }
}
