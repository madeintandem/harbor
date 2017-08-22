import Foundation

class Presenter<V: ViewType> {
  fileprivate(set) weak var view: V!
  fileprivate(set) var isActive: Bool = false

  init(view: V) {
    self.view = view
  }

  func didInitialize() {

  }

  func didBecomeActive() {
    self.isActive = true
  }

  func didResignActive() {
    self.isActive = false
  }
}
