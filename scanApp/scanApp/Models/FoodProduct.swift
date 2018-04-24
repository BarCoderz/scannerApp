//
//  FoodProduct.swift
//  scanApp
//
//  Created by TiAuna Dodd on 4/23/18.
//  Copyright © 2018 Angel Chara'e Mitchell. All rights reserved.
//

import Foundation
class FoodProduct {
    
    var productName: String     // product_name
    var code: String            // code
    var ingredients: [String]?  // ingredients_ids_debug / ingredients_text_debug
    var image_url: URL!         // "image_url"
    var labels: String          // "labels"
    var allergens: String       //'allergens'
    var completion: Bool        //
    
    init(dictionary: [String: Any]) {
        productName = dictionary["product_name"] as? String ?? "No Product Name"
        code = dictionary["code"] as! String
        ingredients = dictionary["ingredients_ids_debug"] as? [String]
        
        let imageString = dictionary["image_url"] as? String ?? ""
        image_url = URL(string: imageString)
        
        labels = dictionary["labels"] as? String ?? ""
        allergens = dictionary["allergens"] as? String ?? ""
        
        let completeStatus = dictionary["states_hierarchy"] as? [String] ?? []
        completion = false
        
        for newString in completeStatus {
            if ((newString.range(of: "en:to-be-completed")) != nil) {
                completion = false
                break
            } else {
                completion = true
            }
        }
    }
    
    class func newProduct(dictionary: [String: Any]) -> FoodProduct {
        var item: FoodProduct
        item = FoodProduct(dictionary: dictionary)
        return item
    }
}
