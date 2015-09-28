//
//  Invocation.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/25/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Nimble

struct Invocation<T> {
    
    let method: Method
    let value:  T?
    
    init(_ method: Method, _ value: T?) {
        self.method = method
        self.value  = value
    }
    
}

func match<T, O: Equatable>(expected: Invocation<O>) -> NonNilMatcherFunc<Invocation<T>> {
    return matcher(expected) { actual, expected in
        // if the force cast to the expected type fails, the test should fail anyways
        return (actual as! O?) == expected
    }
}

func match<T, O: Equatable>(expected: Invocation<[O]>) -> NonNilMatcherFunc<Invocation<T>> {
    return matcher(expected) { actual, expected in
        // if the force cast to the expected type fails, the test should fail anyways
        return (actual as! [O]).elementsEqual(expected!)
    }
}

private func matcher<T, O>(expected: Invocation<O>, comparator: (T?, O?) -> Bool) -> NonNilMatcherFunc<Invocation<T>> {
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
