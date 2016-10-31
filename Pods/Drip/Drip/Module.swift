
/// Base class for modules. Functionality provided by `ModuleType`.
open class Module<C: ComponentType>: ModuleType {
  public typealias Owner = C
  open weak var component: C!
  public required init(_ component: C) {
    self.component = component
  }
}
