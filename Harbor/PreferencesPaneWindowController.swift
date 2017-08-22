import Cocoa

class PreferencesPaneWindowController: NSWindowController, NSWindowDelegate, NSTextFieldDelegate, NSTableViewDataSource, NSTableViewDelegate, PreferencesView {
  enum ColumnIdentifier: String {
    case ShowProject    = "ShowProject"
    case RepositoryName = "RepositoryName"
  }

  //
  // MARK: Dependencies
  fileprivate var component = ViewComponent()
    .parent { Application.component() }
    .module { PreferencesViewModule($0) }

  fileprivate lazy var presenter: PreferencesPresenter<PreferencesPaneWindowController> = self.component.preferences.inject(self)

  //
  // MARK: Interface Elements
  @IBOutlet weak var codeshipAPIKey: TextField!
  @IBOutlet weak var refreshRateTextField: TextField!
  @IBOutlet weak var projectTableView: NSTableView!
  @IBOutlet weak var launchOnLoginCheckbox: NSButton!
  @IBOutlet weak var codeshipAPIKeyError: NSTextField!
  @IBOutlet weak var refreshRateError: NSTextField!
  @IBOutlet weak var savePreferencesButton: NSButton!

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

  func windowDidChangeOcclusionState(_ notification: Notification) {
    let window = notification.object!

    if (window as AnyObject).occlusionState.contains(NSWindowOcclusionState.visible) {
      presenter.didBecomeActive()
    } else {
      presenter.didResignActive()
    }
  }

  //
  // MARK: PreferencesView
  func updateProjects(_ projects: [Project]) {
    projectTableView.reloadData()
  }

  func updateApiKey(_ apiKey: String) {
    codeshipAPIKey.stringValue = apiKey
  }

  func updateRefreshRate(_ refreshRate: String) {
    refreshRateTextField.stringValue = refreshRate
  }

  func updateLaunchOnLogin(_ launchOnLogin: Bool) {
    launchOnLoginCheckbox.on = launchOnLogin
  }

  func updateApiKeyError(_ errorMessage: String) {
    codeshipAPIKeyError.stringValue = errorMessage
    enableOrDisableSaveButton()
  }

  func updateRefreshRateError(_ errorMessage: String) {
    refreshRateError.stringValue = errorMessage
    enableOrDisableSaveButton()
  }

  //
  // MARK: Interface Actions
  @IBAction func launchOnLoginCheckboxClicked(_ sender: AnyObject) {
    presenter.updateLaunchOnLogin(launchOnLoginCheckbox.on)
  }

  @IBAction func isEnabledCheckboxClicked(_ sender: AnyObject) {
    let button = sender as? NSButton

    if let view = button?.nextKeyView as? NSTableCellView {
      let row = projectTableView.row(for: view)
      presenter.toggleEnabledStateForProjectAtIndex(row)
    }
  }

  @IBAction func saveButton(_ sender: AnyObject) {
    presenter.savePreferences()
    close()
  }

  //
  // MARK: NSTextFieldDelegate
  override func controlTextDidChange(_ obj: Notification) {
    if let textField = obj.object as? TextField {
      if textField == codeshipAPIKey {
        presenter.updateApiKey(textField.stringValue)
      } else if textField == refreshRateTextField {
        presenter.updateRefreshRate(textField.stringValue)
      }
      enableOrDisableSaveButton()
    }
  }

  //
  // MARK: NSTableViewDataSource
  func numberOfRows(in tableView: NSTableView) -> Int {
    return presenter.numberOfProjects
  }

  //
  // MARK: NSTableViewDelegate
  func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
    var view: NSView? = nil

    if let tableColumn = tableColumn {
      let project  = presenter.projectAtIndex(row)
      let cellView = tableView.make(withIdentifier: tableColumn.identifier, owner: self) as! NSTableCellView

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
  fileprivate func enableOrDisableSaveButton() {
    savePreferencesButton.isEnabled = codeshipAPIKeyError.stringValue.isEmpty && refreshRateError.stringValue.isEmpty
  }
}
