
import Drip

class AppComponent: Component {
  var system:     SystemModule { return module() }
  var service:    ServiceModule { return module() }
  var interactor: InteractorModule { return module() }
}

class AppModule: Module<AppComponent> {
  required init(_ component: AppComponent) {
    super.init(component)
  }
}
