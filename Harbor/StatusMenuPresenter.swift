import Foundation

class StatusMenuPresenter<V: StatusMenuView> : Presenter<V> {
  //
  // MARK: Dependencies
  private let projectsInteractor: ProjectsInteractor
  private let settings: Settings

  //
  // MARK: Properties
  init(view: V, projectsInteractor: ProjectsInteractor, settings: Settings) {
    self.projectsInteractor = projectsInteractor
    self.settings = settings

    super.init(view: view)
  }

  override func didInitialize() {
    super.didInitialize()

    view.createCoreMenuItems()
    projectsInteractor.addListener(self.handleProjects)
  }

  //
  // MARK: Projects
  private func handleProjects(projects: [Project]) {
    // filter out projects the user disabled and convert them to menu item models
    let disabledProjectIds = settings.disabledProjectIds
    let enabledProjects = projects
      .filter { !disabledProjectIds.contains($0.id) }
      .map { ProjectMenuItemModel(project: $0) }

    view.updateProjects(enabledProjects)
    view.updateBuildStatus(self.buildStatusFromProjects(enabledProjects))
  }

  private func buildStatusFromProjects(projects: [ProjectMenuItemModel]) -> BuildStatus {
    if projects.count == 0 {
      return .Unknown
    } else if (projects.any { $0.isFailing }) {
      return .Failing
    } else if (projects.any { $0.isBuilding }) {
      return .Building
    } else {
      return .Passing
    }
  }
}