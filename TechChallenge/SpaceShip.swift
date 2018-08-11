//
//  SpaceShip.swift
//  TechChallenge
//
//  Created by hamza on 8/10/18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

class SpaceShip {
    
    var _name: String!
    var _longitude: String!
    var _latitude: String!
    var _time: TimeInterval!
    
    init(name: String, longitude: String, latitude: String, time: TimeInterval) {
        _name = name
        _longitude = longitude
        _latitude = latitude
        _time = time
    }
    
}
