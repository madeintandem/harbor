import BrightFutures
import struct Result.AnyError

// MARK: Casting
extension Future {
  public func forceErrorType<E1>() -> Future<T, E1> {
    return mapError { $0 as! E1 }
  }
}

// MARK: AnyFuture
public typealias AnyError
  = Result.AnyError

public typealias AnyFuture
  = Future<Any, AnyError>

func anytyped<T, E: Error>(_ future: Future<T, E>) -> AnyFuture {
  return future.mapError(AnyError.init).forceType()
}

// MARK: Batching
public typealias Producer<T1, T2, E2: Error>
  = (T1) -> Future<T2, E2>

public typealias AnyProducer
  = (Any) -> AnyFuture

public typealias UnitProducer<T1, E1: Error>
  = () -> Future<T1, E1>

public typealias AnyUnitProducer
  = () -> AnyFuture

func anytyped<T1, T2, E2: Error>(
  _ producer: @escaping Producer<T1, T2, E2>
) -> AnyProducer {
  return { value in
    anytyped(producer(value as! T1))
  }
}

func anytyped<T, E: Error>(
  _ producer: @escaping UnitProducer<T, E>
) -> AnyUnitProducer {
  return {
    anytyped(producer())
  }
}

extension Future {
  public struct Batch {
    private let head: AnyUnitProducer
    private let producers: [AnyProducer]

    // MARK: Construction
    private init(
      head initial: @escaping AnyUnitProducer,
      producers current: [AnyProducer]
    ) {
      head = initial
      producers = current
    }

    // MARK: Operators
    public static func head(_ initial: @escaping @autoclosure () -> Future<T, E>) -> Batch {
      return .head(initial as UnitProducer<T, E>)
    }

    public static func head(_ initial: @escaping UnitProducer<T, E>) -> Batch {
      return .init(head: anytyped(initial), producers: [])
    }

    public func then<T1, E1: Error>(
      _ nextProducer: @escaping @autoclosure () -> Future<T1, E1>
    ) -> Future<T1, E1>.Batch {
      return then(nextProducer as UnitProducer<T1, E1>)
    }

    public func then<T1, E1: Error>(
      _ nextProducer: @escaping UnitProducer<T1, E1>
    ) -> Future<T1, E1>.Batch {
      return then({ _ in nextProducer() })
    }

    public func then<T1, E1: Error>(
      _ nextProducer: @escaping Producer<T, T1, E1>
    ) -> Future<T1, E1>.Batch {
      return .init(
        head: head,
        producers: producers + [anytyped(nextProducer)]
      )
    }

    public func tail<T1, E1: Error>(
      _ tailProducer: @escaping @autoclosure () -> Future<T1, E1>
    ) -> Future<T1, AnyError> {
      return tail(tailProducer as UnitProducer<T1, E1>)
    }

    public func tail<T1, E1: Error>(
      _ tailProducer: @escaping UnitProducer<T1, E1>
    ) -> Future<T1, AnyError> {
      return tail({ _ in tailProducer() })
    }

    public func tail<T1, E1: Error>(
      _ tailProducer: @escaping Producer<T, T1, E1>
    ) -> Future<T1, AnyError> {
      return producers
        .reduce(head()) { prev, next in
          prev.flatMap(MaxStackDepthExecutionContext, f: next)
        }
        .flatMap { arg in
          tailProducer(arg as! T).mapError(AnyError.init)
        }
    }
  }
}
