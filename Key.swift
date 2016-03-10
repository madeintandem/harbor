//
//  Key.swift
//  Harbor
//
//  Created by Ty Cobb on 10/1/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

struct Key {
    private let type: Any.Type
    
    init(type: Any.Type) {
        self.type = type
    }
}

// MARK: Hashable
extension Key : Hashable {
    var hashValue: Int {
        return String(self.type).hashValue
    }
}

// MARK: Equatable
func ==(lhs: Key, rhs: Key) -> Bool {
    return lhs.type == rhs.type
}
