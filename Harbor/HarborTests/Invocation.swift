//
//  Invocation.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/25/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

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

func match<M, T, O: Equatable>(expected: Invocation<M, O>) -> NonNilMatcherFunc<Invocation<M, T>> {
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
