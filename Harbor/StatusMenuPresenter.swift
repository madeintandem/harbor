import Foundation

class StatusMenuPresenter<V: StatusMenuView> : Presenter<V> {
  //
  // MARK: Dependencies
  //

  private let projectsInteractor: ProjectsInteractor
  private let settingsManager: SettingsManager

  //
  // MARK: Properties
  //

  init(
    view: V,
    projectsInteractor: ProjectsInteractor = core().inject(),
    settingsManager: SettingsManager = core().inject()) {

      self.projectsInteractor = projectsInteractor
      self.settingsManager = settingsManager

      super.init(view: view)
  }

  override func didInitialize() {
    super.didInitialize()

    self.view.createCoreMenuItems()
    self.projectsInteractor.addListener(self.handleProjects)
  }

  //
  // MARK: Projects
  //

  private func handleProjects(projects: [Project]) {
    // filter out projects the user disabled and convert them to menu item models
    let disabledProjectIds = self.settingsManager.disabledProjectIds
    let enabledProjects = projects
      .filter { !disabledProjectIds.contains($0.id) }
      .map { ProjectMenuItemModel(project: $0) }

    self.view.updateProjects(enabledProjects)
    self.view.updateBuildStatus(self.buildStatusFromProjects(enabledProjects))
  }

  private func buildStatusFromProjects(projects: [ProjectMenuItemModel]) -> BuildStatus {
    if projects.count == 0 {
      return .Unknown
    } else if (projects.any { $0.isFailing }) {
      return .Failing
    } else {
      return .Passing
    }
  }
}