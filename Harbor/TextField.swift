import AppKit

class TextField: NSTextField {
  private let commandKey = NSEventModifierFlags.command.rawValue

  override func performKeyEquivalent(with event: NSEvent) -> Bool {
    if let key = self.unmodifiedKeyForEvent(event: event) {
      if let action = self.actionForKey(key: key) {
        if NSApp.sendAction(action, to:nil, from:self) {
          return true
        }
      }
    }

    return super.performKeyEquivalent(with: event)
  }

  func unmodifiedKeyForEvent(event: NSEvent) -> String? {
    if event.type == .keyDown {
      if (event.modifierFlags.rawValue & NSEventModifierFlags.deviceIndependentFlagsMask.rawValue) == commandKey {
        return event.charactersIgnoringModifiers
      }
    }

    return nil
  }

  func actionForKey(key: String) -> Selector? {
    switch(key) {
    case "x":
      return #selector(NSText.cut(_:))
    case "c":
      return #selector(NSText.copy(_:))
    case "v":
      return #selector(NSText.paste(_:))
    default:
      return nil
    }
  }
}
