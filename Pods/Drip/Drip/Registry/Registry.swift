/**
 Registry encapsulating a component's storage. Classes conforming to `ComponentType`
 should declare and instantiate a registry, i.e.

 `let registry = Registry()`
*/
open class Registry {
  fileprivate var modules    = [Key: Any]()
  fileprivate var parents    = [Key: Any]()
  fileprivate var generators = [Key: Any]()

  public init() {}
}

// MARK: Parents
extension Registry {
  func get<C: ComponentType>() throws -> C {
    guard let parent = parents[Key(C.self)] as? C else {
      throw DripError.componentNotFound(type: C.self)
    }

    return parent
  }

  func set<C: ComponentType>(_ value: C?) {
    parents[Key(C.self)] = value
  }
}

// MARK: Modules
extension Registry {
  func get<M: ModuleType>(_ key: KeyConvertible) throws -> M {
    guard let module = modules[key.key()] as? M else {
      throw DripError.moduleNotFound(type: M.self)
    }

    return module
  }

  func set<M: ModuleType>(_ key: KeyConvertible, value: M?) {
    modules[key.key()] = value
  }
}

// MARK: Generators
extension Registry {
  func get<C: ComponentType, T>(_ key: KeyConvertible) -> ((C) -> T)? {
    return generators[key.key()] as? (C) -> T
  }

  func set<C: ComponentType, T>(_ key: KeyConvertible, value: @escaping (C) -> T) {
    generators[key.key()] = value
  }
}
