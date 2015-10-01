//
//  Invocation.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/25/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Harbor
import Nimble

protocol MethodType : Equatable {
    
}

struct Invocation<M: MethodType, T> {
    
    let method: M
    let value:  T?
    
    init(_ method: M, _ value: T?) {
        self.method = method
        self.value  = value
    }
    
}

//
// MARK: Convenience Initializers
//

let notificationInvocation = { (method: MockNotificationCenter.Method, name: SettingsManager.NotificationName) in
    return Invocation(method, name.rawValue)
}

//
// MARK: Nimble Matchers
//

func match<M, A, E: Equatable>(expected: Invocation<M, E>) -> NonNilMatcherFunc<Invocation<M, A>> {
    return matcher(expected, comparator: compareSingle)
}

func match<M, A, E: Equatable>(expected: Invocation<M, [E]>) -> NonNilMatcherFunc<Invocation<M, A>> {
    return matcher(expected, comparator: compareArray)

}

func haveAnyMatch<S: SequenceType, M, A, E: Equatable where S.Generator.Element == Invocation<M, A>>(expected: Invocation<M, E>) -> NonNilMatcherFunc<S> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        var result = false
        
        if let actualSequence = try actualExpression.evaluate() {
            for actual in actualSequence {
                if compare(actual, expected, compareSingle) {
                    result = true
                }
            }
        }
        
        return result
    }
}

// helpers

private func matcher<M, A, E>(expected: Invocation<M, E>, comparator: (A?, E?) -> Bool) -> NonNilMatcherFunc<Invocation<M, A>> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        if let actual = try actualExpression.evaluate() {
            return compare(actual, expected, comparator)
        }
        
        return false
    }
}

private func compare<M, A, E>(actual: Invocation<M, A>, _ expected: Invocation<M, E>, _ comparator: (A?, E?) -> Bool) -> Bool {
    // check methods and allow the comparator to evaluate value equality
    let methodsEqual = actual.method == expected.method
    let valuesEqual  = comparator(actual.value, expected.value)
    
    return methodsEqual && valuesEqual
}

private func compareSingle<A, E: Equatable>(actual: A?, expected: E?) -> Bool {
    // if the force cast to the expected type fails, the test should fail anyways
    return (actual as! E?) == expected
}

private func compareArray<A, E: Equatable>(actual: A?, expected: [E]?) -> Bool {
    // if the force cast to the expected type fails, the test should fail anyways
    return (actual as! [E]).elementsEqual(expected!)
}
