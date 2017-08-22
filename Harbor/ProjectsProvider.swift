import Foundation

class ProjectsProvider : ProjectsInteractor {
  //
  // MARK: dependencies
  //
  fileprivate let settings:    SettingsType
  fileprivate let codeshipApi: CodeshipApiType

  //
  // MARK: properties
  //
  fileprivate var projects:  [Project]
  fileprivate var listeners: [ProjectHandler]

  init(api: CodeshipApiType, settings: SettingsType) {
    self.projects    = [Project]()
    self.listeners   = [ProjectHandler]()
    self.settings    = settings
    self.codeshipApi = api

    settings.observeNotification(.ApiKey) { _ in
      self.refreshProjects()
    }

    settings.observeNotification(.DisabledProjects) { _ in
      self.refreshCurrentProjects()
    }
  }

  func refreshProjects() {
    codeshipApi.getProjects(didRefreshProjects, errorHandler: { error in
      debugPrint(error)
    })
  }

  func refreshCurrentProjects() {
    didRefreshProjects(projects)
  }

  fileprivate func didRefreshProjects(_ projects: [Project]){
    // update our projects hidden state appropriately according to the user settings
    for project in projects {
      project.isEnabled = !settings.disabledProjectIds.contains(project.id)
    }

    self.projects = projects

    for listener in listeners {
      listener(projects)
    }
  }

  func addListener(_ listener: @escaping ProjectHandler){
    listeners.append(listener)
    listener(projects)
  }
}
