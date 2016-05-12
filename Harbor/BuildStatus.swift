import Cocoa

enum BuildStatus : String {
  case Unknown  = "codeshipLogo_black"
  case Passing  = "codeshipLogo_green"
  case Failing  = "codeshipLogo_red"
  case Building = "codeshipLogo_blue"

  func icon() -> NSImage {
    let image = NSImage(named: self.rawValue)!
    // allows black icon to work with light & dark menubars
    image.template = self == .Unknown

    return image
  }
}