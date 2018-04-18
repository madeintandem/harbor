extension Array {
  subscript (safe index: Index) -> Element? {
    return index < count ? self[index] : nil
  }
}
