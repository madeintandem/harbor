
func cache<I, O>(_ function: @escaping (I) -> O) -> (I) -> O {
  var memo: O?

  return { input in
    memo = memo ?? function(input)
    return memo!
  }
}
