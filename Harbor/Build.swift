import Foundation

final class Build: ResponseObjectSerializable, ResponseCollectionSerializable {
  var id: Int?
  var uuid: String?
  var projectID: Int?
  var status: Status?
  var gitHubUsername: String?
  var commitID: String?
  var message: String?
  var branch: String?
  var startedAt: NSDate?
  var finishedAt: NSDate?
  var codeshipLinkString: String?

  init?(response: NSHTTPURLResponse, representation: AnyObject){
    self.id = representation.valueForKeyPath("id") as? Int
    self.uuid = representation.valueForKeyPath("uuid") as? String
    self.projectID = representation.valueForKeyPath("project_id") as? Int
    self.status = getStatus(representation.valueForKeyPath("status") as? String)
    self.gitHubUsername = representation.valueForKeyPath("github_username") as? String
    self.commitID = representation.valueForKeyPath("commit_id") as? String
    self.message = representation.valueForKeyPath("message") as? String
    self.branch = representation.valueForKeyPath("branch") as? String
    self.startedAt = self.convertDateFromString(representation.valueForKeyPath("started_at") as? String)
    if let finishedAtString = representation.valueForKeyPath("finished_at") as? String{
      self.finishedAt = self.convertDateFromString(finishedAtString)
    }
  }

  private func getStatus(stringStatus: String?) -> Status? {
    if let actualStatus = stringStatus {
      switch actualStatus {
        case "success":
          return .Success
        case "error":
          return .Error
        default:
          return .Building
        }
      }
      return nil
    }

  static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Build] {
    var builds: [Build] = []

    if let representation = representation.valueForKeyPath("builds") as? [[String: AnyObject]] {
      for buildRepresentation in representation {
        if let build = Build(response: response, representation: buildRepresentation) {
          builds.append(build)
        }
      }
    }
    return builds
  }

  func convertDateFromString(aString: String?) -> NSDate{
    let dateFormatter = NSDateFormatter();
    dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSSZ"

    var date : String
    if let dateString = aString {
      date = dateString
    } else {
      date = ""
    }
    return dateFormatter.dateFromString(date)!
  }
}