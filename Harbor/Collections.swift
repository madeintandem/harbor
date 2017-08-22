extension Sequence {
  func any(_ predicate: (Iterator.Element) -> Bool) -> Bool {
    for element in self {
      if(predicate(element)) {
        return true
      }
    }

    return false
  }
}
