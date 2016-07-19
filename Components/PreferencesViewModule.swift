
class PreferencesViewModule: ViewModule {
  func inject<V: PreferencesView>(view: V) -> PreferencesPresenter<V> {
    return single { component in
      PreferencesPresenter(
        view: view,
        projectsInteractor: component.app.interactor.inject(),
        settings: component.app.interactor.inject(),
        timerCoordinator: component.app.interactor.inject())
    }
  }
}
