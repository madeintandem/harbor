import Harbor

extension Ui {
  static func head(_ value: String) {
    Ui.info(value)
  }

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

  static func charify(_ index: Int) -> Character {
    guard let scalar = Unicode.Scalar((97 + index) as Int) else {
      fatalError("could not convert \(index) to character")
    }

    return Character(scalar)
  }
}
