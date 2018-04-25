// MARK: Commands
extension ListBuilds.Failure: CustomStringConvertible {
  var description: String {
    switch self {
      case .hasNoQuery:
        return "builds must specify a query parameter"
    }
  }
}
