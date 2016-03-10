import Foundation

class Presenter<V: ViewType> {
  private(set) weak var view: V!
  private(set) var isActive: Bool = false

  required init(view: V) {
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