import Foundation

struct VerifierOf : Verifiable {
  private let verifier: (Any) -> Bool

  init<E: Equatable>(_ element: E?) {
    self.verifier = { actual in
      guard let element = element else {
        return false
      }

      return (actual as! E) == element
    }
  }

  init<S: SequenceType where S.Generator.Element: Equatable>(_ sequence: S?) {
    self.verifier = { actual in
      guard let sequence = sequence else {
        return false
      }

      return (actual as! S).elementsEqual(sequence)
    }
  }

  func verify(actual: Any) -> Bool {
    return self.verifier(actual)
  }
}