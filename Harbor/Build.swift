import Foundation
import ObjectMapper

final class Build: Mappable {
  enum Status : String {
    case Unknown  = "codeshipLogo_black"
    case Passing  = "codeshipLogo_green"
    case Failing  = "codeshipLogo_red"
    case Building = "codeshipLogo_blue"

    func icon() -> NSImage {
      let image = NSImage(named: self.rawValue)!
      // allows black icon to work with light & dark menubars
      image.template = self == .Unknown

      return image
    }
  }

  static let dateFormatter = NSDateFormatter()
  var id: Int?
  var uuid: String?
  var projectID: Int?
  var status: Status
  var gitHubUsername: String?
  var commitID: String?
  var message: String?
  var branch: String?
  var startedAt: NSDate?
  var finishedAt: NSDate?
  var codeshipLinkString: String?

  let transformDate = TransformOf<NSDate, String>(
    fromJSON: Build.convertDateFromString,
    toJSON: { _ in "" }
  )

  // MARK: ObjectMapper - Mappable
  init(_ map: Map) {
    status = .Unknown
  }

  func mapping(map: Map) {
    id             <- map["id"]
    uuid           <- map["uuid"]
    projectID      <- map["project_id"]
    status         <- map["status"]
    gitHubUsername <- map["github_username"]
    commitID       <- map["commit_id"]
    message        <- map["message"]
    branch         <- map["branch"]
    startedAt      <- (map["started_at"], transformDate)
    finishedAt     <- (map["finished_at"], transformDate)
  }

//  init?(response: NSHTTPURLResponse, representation: AnyObject){
//    self.id = representation.valueForKeyPath("id") as? Int
//    self.uuid = representation.valueForKeyPath("uuid") as? String
//    self.projectID = representation.valueForKeyPath("project_id") as? Int
//    self.status = representation.valueForKeyPath("status") as? String
//    self.gitHubUsername = representation.valueForKeyPath("github_username") as? String
//    self.commitID = representation.valueForKeyPath("commit_id") as? String
//    self.message = representation.valueForKeyPath("message") as? String
//    self.branch = representation.valueForKeyPath("branch") as? String
//    self.startedAt = self.convertDateFromString(representation.valueForKeyPath("started_at") as? String)
//    if let finishedAtString = representation.valueForKeyPath("finished_at") as? String{
//      self.finishedAt = self.convertDateFromString(finishedAtString)
//    }
//  }

//  static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Build] {
//    var builds: [Build] = []
//
//    if let representation = representation.valueForKeyPath("builds") as? [[String: AnyObject]] {
//      for buildRepresentation in representation {
//        if let build = Build(response: response, representation: buildRepresentation) {
//          builds.append(build)
//        }
//      }
//    }
//    return builds
//  }

  private class func convertDateFromString(aString: String?) -> NSDate? {
    dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"

    var date : String
    if let dateString = aString {
      date = dateString
    } else {
      date = ""
    }

    return dateFormatter.dateFromString(date)
  }
}