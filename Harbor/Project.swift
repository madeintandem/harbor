import Foundation
import ObjectMapper

public final class Project: Equatable, Mappable {
  var id: Int = 0
  var uuid: String = ""
  var repositoryName: String! = ""
  var status : Build.Status = .Unknown
  var builds: [Build] = [Build]()
  var isEnabled : Bool = false

//  let transformStatus = TransformOf<Int, String>(
//    fromJSON: { (value: String?) -> Int? in
//    guard let value = value else { return Int(2) }
//
//    if value == "success" {
//      return Int(0)
//    } else if value == "error" {
//      return Int(1)
//    } else {
//      return Int(2)
//    }
//
//    }, toJSON: { nil })
//

  // MARK: ObjectMapper - Mappable
  public init(_ map: Map) {
    isEnabled = true
//    status = map["builds.0.status"].value()!
  }

  public func mapping(map: Map) {
    id <- map["id"]
    uuid <- map["uuid"]
    repositoryName <- map["repository_name"]
//    status <- (map["builds.0.status"], transformStatus)
    builds <- map["builds"]

  }
}

public func ==(lhs: Project, rhs: Project) -> Bool {
  return lhs.id == rhs.id
}

public final class ProjectCollection: Mappable {
  var projects = [Project]()

  public init(_ map: Map) {  }

  public func mapping(map: Map) {
    projects <- map["projects"]
  }
}