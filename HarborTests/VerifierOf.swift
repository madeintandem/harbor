import Foundation

struct VerifierOf : Verifiable {
  fileprivate let verifier: (Any) -> Bool

  init<E: Equatable>(_ element: E?) {
    self.verifier = { actual in
      guard let element = element else {
        return false
      }

      return (actual as! E) == element
    }
  }

  init<S: Sequence>(_ sequence: S?) where S.Iterator.Element: Equatable {
    self.verifier = { actual in
      guard let sequence = sequence else {
        return false
      }

      return (actual as! S).elementsEqual(sequence)
    }
  }

  func verify(_ actual: Any) -> Bool {
    return self.verifier(actual)
  }
}
