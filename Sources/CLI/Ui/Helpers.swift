import Harbor

extension Ui {
  static func emojify(_ status: Status) -> String {
    switch status {
    case .passed:
      return "✔"
    case .failed:
      return "✘"
    case .building:
      return "Δ"
    case .unknown:
      return "?"
    }
  }
}
