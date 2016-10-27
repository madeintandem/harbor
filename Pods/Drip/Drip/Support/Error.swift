
enum DripError: Error {
  case moduleNotFound(type: Any.Type)
  case componentNotFound(type: Any.Type)
}
