//
//  User.swift
//  MultiplyMe
//
//  Created by Saar Bibla on 5/2/24.
//

import Foundation

struct User: Codable {
    var email           = ""
    var alias           = ""
    var highScore       = 0
    var highestLevel    = 1
    var currentLevel    = 1
}
