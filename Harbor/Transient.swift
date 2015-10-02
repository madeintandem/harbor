//
//  Transient.swift
//  Harbor
//
//  Created by Ty Cobb on 10/1/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

class Transient<T> : Factory {
    typealias Element = T
    
    private var generator: () -> T
    
    init(generator: () -> T) {
        self.generator = generator
    }
    
    func create() -> T {
        return self.generator()
    }
    
}

extension Module {
    
    func transient<T>(generator: () -> T) -> T {
        let factory = Injector.factory {
            return Transient(generator: generator)
        }
        
        return factory.create()
    }
    
}
