//
//  Factory.swift
//  Harbor
//
//  Created by Ty Cobb on 10/1/15.
//  Copyright © 2015 DevMynd. All rights reserved.
//

protocol Factory {
    typealias Element

    func get() -> Element
}
