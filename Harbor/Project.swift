import Foundation
import Alamofire

public final class Project: ResponseObjectSerializable, ResponseCollectionSerializable, Equatable {
  let id: Int
  let uuid: String
  let repositoryName: String!
  let status : Int
  let builds: [Build]
  var isEnabled : Bool

  public init(id: Int) {
    self.id = id
    self.uuid = NSUUID().UUIDString
    self.repositoryName = ""
    self.builds = [Build]()
    self.status = 0
    self.isEnabled = false
  }

  public init?(response:NSHTTPURLResponse, representation:AnyObject){
    self.isEnabled = true

    self.id     = representation.valueForKeyPath("id") as! Int
    self.uuid   = representation.valueForKeyPath("uuid") as! String
    self.builds = Build.collection(response: response, representation: representation).sort({ left, right in
      return left.startedAt!.compare(right.startedAt!) == .OrderedDescending
    })

    if let repositoryName = representation.valueForKeyPath("repository_name") as? String {
      self.repositoryName = repositoryName
    } else {
      self.repositoryName = nil
    }

    let firstBuild = self.builds.first
    // make this an enum
    if firstBuild?.status == "success" {
      self.status = 0
    } else if firstBuild?.status == "error" {
      self.status = 1
    } else {
      self.status = 2
    }
  }

  public static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Project] {
    guard let representations = representation.valueForKeyPath("projects") as? [[String: AnyObject]] else {
      return [Project]()
    }

    // map representations into projects and filter out any unnamed elements
    let projects = representations
      .flatMap { representation in Project(response: response, representation: representation) }
      .filter  { project in project.repositoryName != nil }

    return projects
  }
}

public func ==(lhs: Project, rhs: Project) -> Bool {
  return lhs.id == rhs.id
}