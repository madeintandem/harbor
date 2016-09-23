
/// Base class for components. Functionality provided by `ComponentType`.
open class Component: ComponentType {
  open let registry = Registry()
  public required init() {}
}
