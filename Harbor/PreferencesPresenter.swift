import Foundation
import Cocoa

class PreferencesPresenter<V: PreferencesView> : Presenter<V> {
  //
  // MARK: Dependencies
  private var settings:           SettingsType
  private let projectsInteractor: ProjectsInteractor
  private let timerCoordinator:   TimerCoordinatorType

  //
  // MARK: Properties
  private var apiKey:           String = ""
  private var refreshRate:      Double = 60.0
  private var launchOnLogin:    Bool   = true
  private var allProjects:      [Project]
  private var apiKeyError:      String = ""
  private var refreshRateError: String = ""

  private(set) var needsRefresh: Bool = true

  init(view: V, projectsInteractor: ProjectsInteractor, settings: SettingsType, timerCoordinator: TimerCoordinatorType) {
    self.projectsInteractor = projectsInteractor
    self.settings = settings
    self.timerCoordinator = timerCoordinator
    self.allProjects = [Project]()

    super.init(view: view)
  }

  //
  // MARK: Presentation Cycle
  override func didInitialize() {
    super.didInitialize()
    projectsInteractor.addListener(refreshProjects)
  }

  override func didBecomeActive() {
    super.didBecomeActive()
    refreshIfNecessary()
    timerCoordinator.stopTimer()
  }

  override func didResignActive() {
    super.didResignActive()
    refreshIfNecessary()
    timerCoordinator.startTimer()
  }

  func setNeedsRefresh() {
    if(!needsRefresh) {
      needsRefresh = true
    }
  }

  private func refreshIfNecessary() {
    if(needsRefresh) {
      refreshConfiguration()
      needsRefresh = false
    }
  }

  //
  // MARK: Preferences
  func savePreferences() {
    // persist our configuration
    settings.apiKey = apiKey
    settings.refreshRate = refreshRate

    // serialize the hidden projects
    settings.disabledProjectIds = allProjects.reduce([Int]()) { memo, project in
      var memo = memo

      if !project.isEnabled {
        memo.append(project.id)
      }

      return memo
    }

    needsRefresh = false
  }

  func updateApiKey(apiKey: String) {
    self.apiKey = apiKey
    validateApiKey(apiKey)
    setNeedsRefresh()
  }

  func updateRefreshRate(refreshRate: String) {
    self.refreshRate = (refreshRate as NSString).doubleValue
    validateRefreshRate(refreshRate)
    setNeedsRefresh()
  }

  func updateLaunchOnLogin(launchOnLogin: Bool) {
    self.launchOnLogin = launchOnLogin
    setNeedsRefresh()
  }

  private func refreshConfiguration() {
    // load data from user defaults
    launchOnLogin = settings.launchOnLogin
    refreshRate   = settings.refreshRate
    apiKey        = settings.apiKey

    updateApiKey(apiKey)
    updateRefreshRate(refreshRate.description)

    // update our view after refreshing
    view.updateApiKey(apiKey)
    view.updateRefreshRate(refreshRate.description)
    view.updateLaunchOnLogin(launchOnLogin)
    view.updateApiKeyError(apiKeyError)
    view.updateRefreshRateError(refreshRateError)
  }

  //
  // MARK: Projects
  var numberOfProjects: Int {
    get { return allProjects.count }
  }

  func projectAtIndex(index: Int) -> Project {
    return allProjects[index];
  }

  func toggleEnabledStateForProjectAtIndex(index: Int) {
    let project = projectAtIndex(index)
    project.isEnabled = !project.isEnabled

    setNeedsRefresh()
  }

  private func refreshProjects(projects: [Project]) {
    allProjects = projects

    // notify the view that the projects refreshed
    view.updateProjects(allProjects)
  }

  //
  // MARK: Accessors
  private var defaults: NSUserDefaults {
    get { return NSUserDefaults.standardUserDefaults() }
  }

  //
  // MARK: Validations
  private func validateApiKey(value: String) {
    if value.isEmpty {
      apiKeyError = "can't be blank"
    } else {
      apiKeyError = ""
    }

    view.updateApiKeyError(apiKeyError)
  }

  private func validateRefreshRate(value: String) {
    let doubleValue = Double(value)

    if doubleValue == nil {
      refreshRateError = "must be a number"
    } else if !(5 ... 600 ~= doubleValue!) {
      refreshRateError = "must be between 5 and 600 seconds"
    } else {
      refreshRateError = ""
    }

    view.updateRefreshRateError(refreshRateError)
  }
}