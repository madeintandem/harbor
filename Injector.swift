//
//  Injector.swift
//  Harbor
//
//  Created by Ty Cobb on 10/1/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Foundation

class Injector {
    
    //
    // MARK: Bootstrapping
    //
   
    private static var instance: Injector!
  
    class func module<M>(type: M.Type, _ module: M) -> Builder {
        instance = nil
        
        let builder = Builder()
        builder.module(type, module)
        
        return builder
    }
    
    private class func start(modules: [Key: Any]) {
        instance = Injector(modules: modules)
    }
    
    //
    // MARK: Properties
    //
    
    private let modules:   [Key: Any]
    private var factories: [Key: Any]
    
    private init(modules: [Key: Any]) {
        self.modules   = modules
        self.factories = [Key: Any]()
    }
    
    //
    // MARK: Modules
    //
    
    class func module<M>() -> M {
        let key = Key(type: M.self)
        let module = instance.modules[key] as! M
        return module
    }
    
    //
    // MARK: Factories
    //
    
    class func factory<F: Factory>(constructor: () -> F) -> F {
        var result: F
        
        let key     = Key(type: F.Element.self)
        let factory = instance.factories[key] as! F?
        
        if let factory = factory {
            result = factory
        } else {
            result = constructor()
            instance.factories[key] = result
        }
        
        return result
    }
    
    //
    // MARK: Builder
    //
   
    class Builder {
        
        private var modules: [Key: Any]
        
        init() {
            self.modules = [Key: Any]()
        }
        
        func module<M>(type: M.Type, _ module: M) -> Self {
            let key = Key(type: type)
            self.modules[key] = module
            return self
        }
        
        func start() {
            Injector.start(self.modules)
        }
        
    }
    
}


