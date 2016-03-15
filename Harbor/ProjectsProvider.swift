import Foundation

typealias ProjectHandler = ([Project] -> Void)

protocol ProjectsInteractor {
  func refreshProjects()
  func refreshCurrentProjects()
  func addListener(listener: ProjectHandler)
}

class ProjectsProvider : ProjectsInteractor {
  //
  // MARK: dependencies
  //
  private let settings:    Settings
  private let codeshipApi: CodeshipApiType

  //
  // MARK: properties
  //
  private var projects:  [Project]
  private var listeners: [ProjectHandler]

  init(api: CodeshipApiType, settings: Settings) {
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

  private func didRefreshProjects(projects: [Project]){
    // update our projects hidden state appropriately according to the user settings
    for project in projects {
      project.isEnabled = !settings.disabledProjectIds.contains(project.id)
    }

    self.projects = projects

    for listener in listeners {
      listener(projects)
    }
  }

  func addListener(listener: ProjectHandler){
    listeners.append(listener)
    listener(projects)
  }
}