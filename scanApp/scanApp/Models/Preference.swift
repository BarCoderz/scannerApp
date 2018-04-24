//
//  Preference.swift
//  scanApp
//
//  Created by Angel Chara'e Mitchell on 4/24/18.
//  Copyright © 2018 Angel Chara'e Mitchell. All rights reserved.
//

import Foundation
class Preference {
    var uVegan: Bool!
    var uVegetarian: Bool!
    var urAllergens: [String]!
    
    init() {
        uVegan = true
        uVegetarian = true
        urAllergens = []
    }
}
