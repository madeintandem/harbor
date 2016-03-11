class PreferencesViewModule: ViewModule {
  func inject<V: PreferencesView>(view: V) -> PreferencesPresenter<V> {
    return single {
      PreferencesPresenter(
        view: view,
        projectsInteractor: $0.app.interactor.inject(),
        settings: $0.app.interactor.inject())
    }
  }
}