import Alamofire
import BrightFutures
import SwiftyJSON

struct NetworkError: Error {
  let statusCode: Int
  let json: JSON
}

extension DataRequest {
  func responseJson<E>(onError: @escaping (Error) -> E) -> Future<JSON, E> {
    return Future { complete in
      self.response(responseSerializer: ResponseSerializers.Json) { response in
        switch response.result {
          case .success(let data):
            complete(.success(data))
          case .failure(let error):
            complete(.failure(onError(error)))
        }
      }
    }
  }
}

private struct ResponseSerializers {
  static let Json = DataResponseSerializer<JSON> { request, response, data, error in
    if let error = error {
      return .failure(error)
    }

    guard let response = response else {
      return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
    }

    guard let data = data, data.count > 0 else {
      return .failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength))
    }

    let json: JSON
    do {
      json = try JSON(data: data)
    } catch {
      return .failure(AFError.responseSerializationFailed(reason: .jsonSerializationFailed(error: error)))
    }

    guard response.statusCode < 400 else {
      return .failure(NetworkError(statusCode: response.statusCode, json: json))
    }

    return .success(json)
  }
}
