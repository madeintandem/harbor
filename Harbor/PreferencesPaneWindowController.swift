import Cocoa

class PreferencesPaneWindowController: NSWindowController, NSWindowDelegate, NSTextFieldDelegate, NSTableViewDataSource, NSTableViewDelegate, PreferencesView {
  enum ColumnIdentifier: String {
    case ShowProject    = "ShowProject"
    case RepositoryName = "RepositoryName"
  }

  //
  // MARK: Dependencies
  private var component = ViewComponent()
    .parent { Application.component() }
    .module { PreferencesViewModule($0) }

  private lazy var presenter: PreferencesPresenter<PreferencesPaneWindowController> = self.component.preferences.inject(self)

  //
  // MARK: Interface Elements
  @IBOutlet weak var codeshipAPIKey: TextField!
  @IBOutlet weak var refreshRateTextField: TextField!
  @IBOutlet weak var projectTableView: NSTableView!
  @IBOutlet weak var launchOnLoginCheckbox: NSButton!
  @IBOutlet weak var codeshipAPIKeyError: NSTextField!
  @IBOutlet weak var refreshRateError: NSTextField!

  override init(window: NSWindow?) {
    super.init(window: window)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func windowDidLoad() {
    super.windowDidLoad()

    self.presenter.didInitialize()
  }

  func windowDidChangeOcclusionState(notification: NSNotification) {
    let window = notification.object!

    if window.occlusionState.contains(NSWindowOcclusionState.Visible) {
      presenter.didBecomeActive()
    } else {
      presenter.didResignActive()
    }
  }

  //
  // MARK: PreferencesView
  func updateProjects(projects: [Project]) {
    projectTableView.reloadData()
  }

  func updateApiKey(apiKey: String) {
    codeshipAPIKey.stringValue = apiKey
  }

  func updateRefreshRate(refreshRate: String) {
    refreshRateTextField.stringValue = refreshRate
  }

  func updateLaunchOnLogin(launchOnLogin: Bool) {
    launchOnLoginCheckbox.enabled = launchOnLogin
  }

  //
  // MARK: Interface Actions
  @IBAction func launchOnLoginCheckboxClicked(sender: AnyObject) {
    presenter.updateLaunchOnLogin(launchOnLoginCheckbox.enabled)
  }

  @IBAction func isEnabledCheckboxClicked(sender: AnyObject) {
    let button = sender as? NSButton

    if let view = button?.nextKeyView as? NSTableCellView {
      let row = projectTableView.rowForView(view)
      presenter.toggleEnabledStateForProjectAtIndex(row)
    }
  }

  @IBAction func saveButton(sender: AnyObject) {
    presenter.savePreferences()
    close()
  }

  //
  // MARK: NSTextFieldDelegate
  override func controlTextDidChange(obj: NSNotification) {
    if let textField = obj.object as? TextField {
      if textField == codeshipAPIKey {
        presenter.updateApiKey(textField.stringValue)
        validateCodeshipAPIKey(textField.stringValue)
      } else if textField == refreshRateTextField {
        presenter.updateRefreshRate(textField.stringValue)
        validateRefreshRate(textField.stringValue)
      }
    }
  }

  //
  // MARK: NSTableViewDataSource
  func numberOfRowsInTableView(tableView: NSTableView) -> Int {
    return presenter.numberOfProjects
  }

  //
  // MARK: NSTableViewDelegate
  func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
    var view: NSView? = nil

    if let tableColumn = tableColumn {
      let project  = presenter.projectAtIndex(row)
      let cellView = tableView.makeViewWithIdentifier(tableColumn.identifier, owner: self) as! NSTableCellView

      switch ColumnIdentifier(rawValue: tableColumn.identifier)! {
      case .ShowProject:
        cellView.objectValue = project.isEnabled ? NSOnState : NSOffState
      case .RepositoryName:
        cellView.textField!.stringValue = project.repositoryName
      }

      view = cellView
    }

    return view
  }

  //
  // MARK: Validations
  func validateCodeshipAPIKey(value: String) {
    if value.isEmpty {
      codeshipAPIKeyError.stringValue = "can't be blank"
    } else {
      codeshipAPIKeyError.stringValue = ""
    }
  }

  func validateRefreshRate(value: String) {
    let doubleValue = Double(value)

    if doubleValue == nil {
      refreshRateError.stringValue = "must be a number"
    } else if !(5 ... 600 ~= doubleValue!) {
      refreshRateError.stringValue = "must be between 5 and 600 seconds"
    } else {
      refreshRateError.stringValue = ""
    }
  }
}