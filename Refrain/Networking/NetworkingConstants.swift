//
//  NetworkingConstants.swift
//  Refrain
//
//  Created by Kyle on 2018-03-10.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation


enum API_Environment {
    case Production
    case Staging
    case Localhost
}

var usersAPIVersion: Int = 1
var usersAPIURLString = "http://refrain.genoe.ca/api/v\(usersAPIVersion)/users/"
var uesrsAPIURL = URL(string: usersAPIURLString)!
