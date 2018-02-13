import Result
import Alamofire

class CodeshipProvider: ProjectProvider {
  private let baseUrl = "https://codeship.com/api/v1/"
  private let apiKey: String

  init (apiKey: String) {
    self.apiKey = apiKey
  }

  func getProjects (handler: @escaping (Result.Result<[AnyObject], ProjectError>) -> ()) {
    let url = "\(baseUrl)/projects.json?api_key=\(apiKey)"

    Alamofire.request(url).responseJSON { response in
      handler(response.result)
    }
  }
}
