extension Ui {
  static func char(from index: Int, inRange range: Range) -> Character {
    let ord = index + range.lowerBound

    guard
      range.values.contains(ord),
      let scalar = UnicodeScalar(ord)
      else {
        fatalError("\(index) -> \(ord) is out of range \(range.values)")
      }

    return Character(scalar)
  }

  static func code(from string: String, offset: Int, inRange range: Range) -> Int? {
    let char = string[string.index(string.startIndex, offsetBy: offset)]

    guard
      char.unicodeScalars.count == 1,
      let value = char.unicodeScalars.first.map({ Int($0.value) }),
      range.values.contains(value)
      else {
        return nil
    }

    return value - range.values.lowerBound
  }

  enum Range {
    case all
    case letters
    case numbers

    var values: CountableClosedRange<Int> {
      switch self {
      case .all:
        return 0...127
      case .letters:
        return 97...122
      case .numbers:
        return 48...57
      }
    }

    var lowerBound: Int {
      return values.lowerBound
    }
  }
}
