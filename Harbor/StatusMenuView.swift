protocol StatusMenuView : ViewType {
  func createCoreMenuItems()
  func updateBuildStatus(_ status: Build.Status)
  func updateProjects(_ projects: [ProjectMenuItemModel])
}
