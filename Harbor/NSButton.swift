import AppKit

extension NSButton {
  var on: Bool {
    get {
      return (state == NSOnState) ? true : false
    }
    set {
      state = newValue ? NSOnState : NSOffState
    }
  }
}