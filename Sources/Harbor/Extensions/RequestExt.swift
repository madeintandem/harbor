import Alamofire
import BrightFutures

extension DataRequest {
  func responseJson<E>(onError: @escaping (Error) -> E) -> Future<Any, E> {
    return Future { complete in
      self.responseJSON { response in
        switch response.result {
          case .success(let value):
            complete(.success(value))
          case .failure(let error):
            complete(.failure(onError(error)))
        }
      }
    }
  }
}
