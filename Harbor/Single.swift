//
//  Single.swift
//  Harbor
//
//  Created by Ty Cobb on 10/1/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

class Single<T> : Factory {
    typealias Element = T
    
    private var instance: T?
    private let generator: () -> T
    
    init(generator: () -> T) {
        self.generator = generator
    }
   
    func get() -> T {
        if self.instance == nil {
            self.instance = self.generator()
        }
        
        return self.instance!
    }
}

extension Module {
   
    func single<T>(generator: () -> T) -> T {
        let factory = Injector.factory {
            return Single(generator: generator)
        }
        
        return factory.get()
    }
    
}
