
class StatusMenuModule: ViewModule {
  func inject<V: StatusMenuView>(view: V) -> StatusMenuPresenter<V> {
    return single {
      StatusMenuPresenter(
        view: view,
        projectsInteractor: $0.app.interactor.inject(),
        settings: $0.app.interactor.inject())
    }
  }
}