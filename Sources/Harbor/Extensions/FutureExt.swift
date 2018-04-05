import BrightFutures
import Result

public typealias AnyFuture
  = Future<Any, AnyError>

extension Future {
  public func anytyped() -> AnyFuture {
    return mapError { error in AnyError(error) }.forceType()
  }

  public static func serially<T, E: Error>(
    _ futures: Future<T, E>...
    ) -> Future<T, E> {
    precondition(futures.count > 0, "must have at least one future to run serially")

    return futures
      .suffix(from: 1)
      .reduce(futures[0]) { prev, next in
        prev.flatMap(MaxStackDepthExecutionContext) { _ in next }
    }
  }
}
