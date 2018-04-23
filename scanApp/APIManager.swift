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
    
    func getProduct(barcode: String, completion: @escaping (FoodProduct?, Error?) -> ()) {
        let url = URL(string: APIManager.baseUrl + "\(barcode).json")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            
            // This will run when the network request returns
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                if ((dataDictionary["product"] != nil)) {
                    let dictionary = dataDictionary["product"] as! [String: Any]
                    let product = FoodProduct.newProduct(dictionary: dictionary)
                    
                    completion(product, nil)
                }
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
