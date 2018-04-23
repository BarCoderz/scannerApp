//
//  APIManager.swift
//  scanApp
//
//  Created by Kymberlee Hill on 4/23/18.
//  Copyright © 2018 Angel Chara'e Mitchell. All rights reserved.
//

import Foundation
class APIManager {
    static let baseUrl = "https://world.openfoodfacts.org/api/v0/product/"
    var session: URLSession
    
    init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
}

