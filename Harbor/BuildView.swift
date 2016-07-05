import Cocoa

class BuildView: NSView {
  private var model: BuildViewModel!

  @IBOutlet var view: NSView!
  @IBOutlet weak var buildMessageLabel: NSTextField!
  @IBOutlet weak var dateAndUsernameLabel: NSTextField!

  convenience init(model: BuildViewModel) {
    self.init(frame: NSRect(x: 0, y: 0, width: 300, height: 53))

    self.model = model
    self.buildMessageLabel.stringValue    = model.message
    self.dateAndUsernameLabel.stringValue = model.authorshipInformation()
  }

  func didClickBuild(sender: NSMenuItem) {
    self.model.openBuildUrl()
  }

  override init(frame frameRect: NSRect) {
    super.init(frame: frameRect)

    NSBundle.mainBundle().loadNibNamed("BuildView", owner: self, topLevelObjects: nil)
    let contentFrame = NSRect(x: 0, y: 0, width: frame.width, height: frame.height)
    self.view.frame = contentFrame
    self.addSubview(self.view)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // enables highlighting of view on mouseover
  override func drawRect(dirtyRect: NSRect) {
    let menuItem = self.enclosingMenuItem
    if menuItem?.highlighted == true {
        if (NSAppearance.currentAppearance().name.hasPrefix("NSAppearanceNameVibrantDark")) {
            NSColor(red: 0.004, green: 0.380, blue: 0.750, alpha: 1.0).set()
        }
        else {
            NSColor(red: 0.705, green: 0.847, blue: 0.989, alpha: 1.0).set()
        }
      NSBezierPath.fillRect(dirtyRect)
    } else {
      super.drawRect(dirtyRect)
    }
  }

  // enables selecting view on mouseup
  override func mouseUp(theEvent: NSEvent) {
    let menuItem = self.enclosingMenuItem
    let menu = menuItem?.menu
    menu?.cancelTracking()

    let menuItemIndex = menu?.indexOfItem(menuItem!)
    menu?.performActionForItemAtIndex(menuItemIndex!)
    debugPrint(menu!.delegate)
  }
}

extension BuildView {
  class func menuItemForModel(model: BuildViewModel) -> NSMenuItem {
    let result = NSMenuItem(title: model.message, action: #selector(BuildView.didClickBuild(_:)), keyEquivalent: "")
    result.representedObject = model.build

    result.view   = BuildView(model: model)
    result.target = result.view

    return result
  }
}