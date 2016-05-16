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

  static var dateFormatter: NSDateFormatter {
    if _dateFormatter == nil {
      _dateFormatter = NSDateFormatter()
      _dateFormatter!.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
    }
    return _dateFormatter!
  }
  private static var _dateFormatter: NSDateFormatter?
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

  private class func convertDateFromString(aString: String?) -> NSDate? {
    var date : String
    if let dateString = aString {
      date = dateString
    } else {
      date = ""
    }

    return dateFormatter.dateFromString(date)
  }
}