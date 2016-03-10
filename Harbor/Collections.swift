//
//  Collections.swift
//  Harbor
//
//  Created by Ty Cobb on 10/2/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

extension SequenceType {
    
    func any(predicate: (Generator.Element) -> Bool) -> Bool {
        for element in self {
            if(predicate(element)) {
                return true
            }
        }
        
        return false
    }
    
}