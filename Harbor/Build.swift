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
      image.isTemplate = self == .Unknown

      return image
    }
  }

  var id: Int?
  var uuid: String?
  var projectID: Int?
  var status = Build.Status.Unknown
  var gitHubUsername: String?
  var commitID: String?
  var message: String?
  var branch: String?
  var startedAt: Date?
  var finishedAt: Date?
  var codeshipLinkString: String?


  // MARK: ObjectMapper - Mappable
  init(_ map: Map) {  }

  func mapping(_ map: Map) {
    id             <- map["id"]
    uuid           <- map["uuid"]
    projectID      <- map["project_id"]
    status         <- map["status"]
    gitHubUsername <- map["github_username"]
    commitID       <- map["commit_id"]
    message        <- map["message"]
    branch         <- map["branch"]
    startedAt      <- (map["started_at"], Transforms.date)
    finishedAt     <- (map["finished_at"], Transforms.date)
  }

  fileprivate struct Transforms {
    static let dateFormatter: DateFormatter = ({ () -> DateFormatter in
      let formatter = DateFormatter()
      formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"
      return formatter
    })()

    static let date = TransformOf<Date, String>(
      fromJSON: Transforms.convertDateFromString,
      toJSON: { _ in "" }
    )

    fileprivate static func convertDateFromString(_ aString: String?) -> Date? {
      var date : String
      if let dateString = aString {
        date = dateString
      } else {
        date = ""
      }

      return dateFormatter.date(from: date)
    }
  }
}
