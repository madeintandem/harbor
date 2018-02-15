import Alamofire
import BrightFutures
import SwiftyJSON

extension DataRequest {
  func responseJson<E>(onError: @escaping (Error) -> E) -> Future<JSON, E> {
    return Future { complete in
      self.response(responseSerializer: ResponseSerializers.json) { response in
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

private struct ResponseSerializers {
  static let json = DataResponseSerializer<JSON> { _, _, data, error in
    if let error = error {
      return .failure(error)
    }

    guard let data = data, data.count > 0 else {
      return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
    }

    do {
      return .success(try JSON(data: data))
    } catch {
      return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
    }
  }
}
