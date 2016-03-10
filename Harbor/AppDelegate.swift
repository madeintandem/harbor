import Cocoa
import Alamofire

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, StatusMenuDelegate {
  @IBOutlet weak var statusItemMenu: StatusMenu!

  var preferencesWindowController: PreferencesPaneWindowController!

  var settings:         SettingsManager!
  var projectsProvider: ProjectsInteractor!
  var timerCoordinator: TimerCoordinator!

  override init() {
    super.init()

    // inject the proper modules
    Injector
      .module(CoreModuleType.self, CoreModule()).start()
  }

  func applicationDidFinishLaunching(aNotification: NSNotification) {
    preferencesWindowController = PreferencesPaneWindowController(windowNibName: "PreferencesPaneWindowController")

    settings         = core().inject()
    projectsProvider = core().inject()
    timerCoordinator = core().inject()

    statusItemMenu.statusMenuDelegate = self

    // run startup logic
    self.startup()
  }

  //
  // MARK: Startup
  //

  private func startup() {
    settings.startup()
    timerCoordinator.startup()

    self.refreshProjects()
  }

  private func refreshProjects() {
    if !settings.apiKey.isEmpty {
      projectsProvider.refreshProjects()
    } else {
      self.showPreferencesPane()
    }
  }


  //
  // MARK: StatusMenuDelegate
  //

  func statusMenuDidSelectPreferences(statusMenu: StatusMenu) {
    self.showPreferencesPane()
  }

  private func showPreferencesPane() {
    preferencesWindowController.window?.center()
    preferencesWindowController.window?.orderFront(self)

    // Show your window in front of all other apps
    NSApp.activateIgnoringOtherApps(true)
  }
}