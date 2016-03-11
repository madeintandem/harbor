import Alamofire

protocol CodeshipApiType {
  func getProjects(successHandler: ([Project]) -> (), errorHandler: (String)->())
}

class CodeshipApi : CodeshipApiType {
  static let apiRootPath = "https://codeship.com/api/v1/projects.json?api_key="

  private let settingsManager: SettingsManager

  init(settings: SettingsManager) {
    self.settingsManager = settings
  }

  func getProjects(successHandler: ([Project]) -> (), errorHandler: (String)->()){
    let apiKey = settingsManager.apiKey
    let apiURL = "\(CodeshipApi.apiRootPath)\(apiKey)"

    Alamofire.request(.GET, apiURL).responseCollection{(response: Response<[Project], NSError> ) in
      if(response.result.isSuccess) {
        successHandler(response.result.value!)
      } else {
        //log the error
        debugPrint(response.result)
        errorHandler("Error!")
      }
    }
  }
}