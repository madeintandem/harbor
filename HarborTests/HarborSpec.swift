//
//  HarborSpec.swift
//  Harbor
//
//  Created by Ty Cobb on 10/1/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

import Quick
@testable import Harbor

class HarborSpec : QuickSpec {
    
    override func spec() {
        beforeEach {
            Injector
                .module(CoreModuleType.self, MockCoreModule()).start()
        }
    }
    
}
