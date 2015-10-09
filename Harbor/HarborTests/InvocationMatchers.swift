//
//  InvocationMatchers.swift
//  Harbor
//
//  Created by Ty Cobb on 10/9/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Nimble

func match<M, E: Verifiable>(expected: ExpectedInvocation<M, E>) -> NonNilMatcherFunc<Invocation<M>> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        if let actual = try actualExpression.evaluate() {
            return verifyInvocations(actual, expected)
        }
        
        return false
    }
}

func haveAnyMatch<S: SequenceType, M, E: Verifiable where S.Generator.Element == Invocation<M>>(expected: ExpectedInvocation<M, E>) -> NonNilMatcherFunc<S> {
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

private func verifyInvocations<M, E: Verifiable>(actual: Invocation<M>, _ expected: ExpectedInvocation<M, E>) -> Bool {
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
