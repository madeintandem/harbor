extension SequenceType {
  func any(predicate: (Generator.Element) -> Bool) -> Bool {
    for element in self {
      if(predicate(element)) {
        return true
      }
    }

    return false
  }
}