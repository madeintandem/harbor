import Nimble

func match<M, E: Verifiable>(_ expected: ExpectedInvocation<M, E>) -> NonNilMatcherFunc<Invocation<M>> {
  return NonNilMatcherFunc { actualExpression, failureMessage in
    if let actual = try actualExpression.evaluate() {
      return verifyInvocations(actual, expected)
    }

    return false
  }
}

func haveAnyMatch<S: Sequence, M, E: Verifiable>(_ expected: ExpectedInvocation<M, E>) -> NonNilMatcherFunc<S> where S.Iterator.Element == Invocation<M> {
  return NonNilMatcherFunc { actualExpression, failureMessage in
    guard let actual = try actualExpression.evaluate() else {
      return false
    }

    // if we successfully match any invocation, then the match succeeds
    for invocation in actual {
      if verifyInvocations(invocation, expected) {
        return true
      }
    }

    return false
  }
}

//
// MARK: Helpers
//

private func verifyInvocations<M, E: Verifiable>(_ actual: Invocation<M>, _ expected: ExpectedInvocation<M, E>) -> Bool {
  // check methods and allow the comparator to evaluate value equality
  let methodsEqual = actual.method == expected.method
  // TODO: customize failure message if method comparison fails
  if !methodsEqual {
    return false
  }

  if actual.value == nil && expected.value == nil {
    return true
  }

  // TODO: customize failure message if only actual is nil
  guard let actualValue = actual.value else {
    return false
  }

  // TODO: customize failure message if only expected is nil
  guard let expectedValue = expected.value else {
    return false
  }

  return expectedValue.verify(actualValue)
}
