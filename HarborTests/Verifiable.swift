//
//  Verifiable.swift
//  Harbor
//
//  Created by Ty Cobb on 10/9/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

protocol Verifiable {
    func verify(actual: Any) -> Bool
}
