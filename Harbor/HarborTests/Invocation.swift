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

func match<M, T, O: Equatable>(expected: Invocation<M, O>) -> NonNilMatcherFunc<Invocation<M, T>> {
    return matcher(expected) { actual, expected in
        // if the force cast to the expected type fails, the test should fail anyways
        return (actual as! O?) == expected
    }
}

func matchInvocation<M, T, O: Equatable>(expected: Invocation<M, O>) -> NonNilMatcherFunc<Invocation<M, T>> {
    return matcher(expected) { actual, expected in
        // if the force cast to the expected type fails, the test should fail anyways
        return (actual as! O?) == expected
    }
}

func match<M, T, O: Equatable>(expected: Invocation<M, [O]>) -> NonNilMatcherFunc<Invocation<M, T>> {
    return matcher(expected) { actual, expected in
        // if the force cast to the expected type fails, the test should fail anyways
        return (actual as! [O]).elementsEqual(expected!)
    }
}

public func haveAnyMatch<U,V where U: SequenceType, V: Matcher>(matcher: V) -> NonNilMatcherFunc<U> {
    return NonNilMatcherFunc<U> { actualExpression, failureMessage in
        failureMessage.actualValue = nil
        if let actualValue = try actualExpression.evaluate() {
            for element in actualValue {
                let exp = Expression(expression: {element}, location: actualExpression.location)
                if matcher.matches(exp, failureMessage: failureMessage) {
                    
                }
            
            }
        }
        
        return true
    }
}

private func createAllPassMatcher<T,U where U: SequenceType, U.Generator.Element == T>
    (elementEvaluator:(Expression<T>, FailureMessage) throws -> Bool) -> NonNilMatcherFunc<U> {
        return NonNilMatcherFunc { actualExpression, failureMessage in
            failureMessage.actualValue = nil
            if let actualValue = try actualExpression.evaluate() {
                for currentElement in actualValue {
                    let exp = Expression(
                        expression: {currentElement}, location: actualExpression.location)
                    if try !elementEvaluator(exp, failureMessage) {
                        failureMessage.postfixMessage =
                            "all \(failureMessage.postfixMessage),"
                            + " but failed first at element <\(stringify(currentElement))>"
                            + " in <\(stringify(actualValue))>"
                        return false
                    }
                }
                failureMessage.postfixMessage = "all \(failureMessage.postfixMessage)"
            } else {
                failureMessage.postfixMessage = "all pass (use beNil() to match nils)"
                return false
            }
            
            return true
        }
}

// helpers

private func matcher<M, T, O>(expected: Invocation<M, O>, comparator: (T?, O?) -> Bool) -> NonNilMatcherFunc<Invocation<M, T>> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        var result = false
        
        if let actual = try actualExpression.evaluate() {
            // check methods and allow the comparator to evaluate value equality
            let methodsEqual = actual.method == expected.method
            let valuesEqual  = comparator(actual.value, expected.value)
            
            result = methodsEqual && valuesEqual
        }
        
        return result
    }
}
