import Alamofire

final class CodeshipClient {
  private let baseUrl = "https://api.codeship.com/v2"

  func request(_ endpoint: String) -> Alamofire.DataRequest {
    return Alamofire.request("\(baseUrl)\(endpoint)")
  }
}
