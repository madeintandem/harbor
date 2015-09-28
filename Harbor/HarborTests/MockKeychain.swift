//
//  MockKeychain.swift
//  Harbor
//
//  Created by Erin Hochstatter on 9/28/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Harbor


class MockKeychain : Keychain {
    
    enum Method : MethodType {
        case SetString
        case StringForKey
    }

    var invocation: Invocation<Method, String>?
    
    func setString(value: String, forKey keyName: String) -> Bool {
        invocation = Invocation(.SetString, value)
        return true
    }
    
    func stringForKey(keyName: String) -> String? {
        invocation = Invocation(.StringForKey, self.invocation?.value)
        return invocation?.value
    }
}