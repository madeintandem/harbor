import Foundation
import ObjectMapper

public final class Project: Equatable, Mappable {
  var id: Int = 0
  var uuid: String = ""
  var repositoryName: String = ""
  var status : Build.Status = .Unknown
  var builds: [Build] = [Build]()
  var isEnabled : Bool = true

  public init(id: Int) {
    self.id = id
    self.uuid = UUID().uuidString
    self.isEnabled = false
  }

  // MARK: ObjectMapper - Mappable
  public init(_ map: Map) { }

  public func mapping(_ map: Map) {
    id             <- map["id"]
    uuid           <- map["uuid"]
    repositoryName <- map["repository_name"]
    status         <- (map["builds.0.status"], Transforms.status)
    builds         <- map["builds"]
  }

  fileprivate struct Transforms {
    static let status = TransformOf<Build.Status, String>(
      fromJSON: Transforms.convertStatusFromString,
      toJSON: { _ in "" }
    )

    fileprivate static func convertStatusFromString(_ value: String?) -> Build.Status? {
      guard let unwrappedValue = value else { return nil }
      switch unwrappedValue {
      case "success":
        return .Passing
      case "error":
        return .Failing
      case "testing":
        return .Building
      default:
        return nil
      }
    }
  }
}

public func ==(lhs: Project, rhs: Project) -> Bool {
  return lhs.id == rhs.id
}

public final class ProjectCollection: Mappable {
  var projects = [Project]()

  public init(_ map: Map) {  }

  public func mapping(_ map: Map) {
    projects <- map["projects"]
  }
}
