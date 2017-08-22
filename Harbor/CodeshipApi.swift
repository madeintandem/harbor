import Alamofire
import AlamofireObjectMapper

protocol CodeshipApiType {
  func getProjects(_ successHandler: @escaping ([Project]) -> (), errorHandler: @escaping (String)->())
}

class CodeshipApi : CodeshipApiType {
  static let apiRootPath = "https://codeship.com/api/v1/projects.json?api_key="

  fileprivate let settings: SettingsType

  init(settings: SettingsType) {
    self.settings = settings
  }

  func getProjects(_ successHandler: @escaping ([Project]) -> (), errorHandler: @escaping (String)->()){
    let apiKey = settings.apiKey
    let apiURL = "\(CodeshipApi.apiRootPath)\(apiKey)"

    Alamofire.request(apiURL).responseObject{ (response: DataResponse<ProjectCollection> ) in
      if(response.result.isSuccess) {
        successHandler(response.result.value!.projects)
      } else {
        //log the error
        debugPrint(response.result)
        errorHandler("Error!")
      }
    }
  }
}
