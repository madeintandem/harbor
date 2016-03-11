import Drip

class ViewComponent: ComponentType {
  let registry = Registry()

  var app: AppComponent { return parent() }
  var status: StatusMenuModule { return module() }
  var preferences: PreferencesViewModule { return module() }
}

class ViewModule: Module<ViewComponent> {
  required init(_ component: ViewComponent) {
    super.init(component)
  }
}