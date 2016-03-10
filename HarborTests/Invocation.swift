//
//  Invocation.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/25/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

// protocol all specialized method types must conform to
protocol MethodType : Equatable {
    
}

// container for invocation generation heleprs
struct Invocations {
    
}

// source invocation mocks can store; erases the value type
struct Invocation<M: MethodType> {
    
    var method: M
    var value:  Any?
    
    init(_ method: M, _ value: Any?) {
        self.method = method
        self.value  = value
    }
    
}

// expected invocation that captures type for running expectations against 
// source invocations
struct ExpectedInvocation<M: MethodType, E> {
    
    let method: M
    let value:  E?
    
    init(_ method: M, _ value: E?) {
        self.method = method
        self.value  = value
    }
    
}
