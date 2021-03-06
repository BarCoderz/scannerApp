//
//  ProductViewController.swift
//  scanApp
//
//  Created by TiAuna Dodd on 4/23/18.
//  Copyright © 2018 Angel Chara'e Mitchell. All rights reserved.
//

import UIKit
import AlamofireImage

class ProductViewController: UIViewController {

    var product: FoodProduct!
    var preferences: Preference!
    var nonVegan = ["gelatin", "milk", "yogurt", "cheese", "butter", "eggs", "honey", "bee pollen", "lactose"]
    var Vegetarian = ["chicken", "pork", "beef", "fish", "duck", "shrimp", "veal", "meat"]
    @IBOutlet weak var ProductImageView: UIImageView!
    @IBOutlet weak var ProductNameLabel: UILabel!
    var imageURL: URL!
    
    @IBOutlet weak var veganLabel: UILabel!
    @IBOutlet weak var veganCheck: UIImageView!
    
    @IBOutlet weak var veggieLabel: UILabel!
    @IBOutlet weak var veggieCheckbox: UIImageView!
    
    @IBOutlet weak var allergensLabel: UILabel!
    @IBOutlet weak var allergensCheck: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        veganLabel.isHidden = true
        veganCheck.isHidden = true
        veggieLabel.isHidden = true
        veggieCheckbox.isHidden = true
        allergensLabel.isHidden = true
        allergensCheck.isHidden = true
        
        ProductNameLabel.text = product.productName
        imageURL = product.image_url

        if imageURL != nil{
            ProductImageView .af_setImage(withURL: imageURL)
        }
        
        if preferences.uVegan { setVeganAlert() }
        
        if preferences.uVegetarian { setVeggieAlert() }
        
        if preferences.urAllergens != nil { setAllergenAlert() }
    }
    
    //  Checks if product is considered Vegan - NOT COMPLETE
    func isVegan() -> Bool {
        if isVegetarian() {
            for item in product.labels! {
                if ((item.range(of: "vegan")) != nil) {
                    return true
                }
            }
            
            // check ingredients vs. non-vegan array
            for item in nonVegan {
                if (product.ingredients?.contains(item))! {
                    return false
                }
            }
            
            return true // no matches found
            
        } else {
            return false // not Vegetarian, definitely not Vegan
        }
        
    }
    
    // Checks if product is considered Vegetarian - NOT COMPLETE
    func isVegetarian() -> Bool  {
        for item in product.labels! {
            if ((item.range(of: "vegetarian")) != nil) {
                return true
            }
        }
        
        // check ingredients vs. vegetarian array
        for item in Vegetarian {
            if (product.ingredients?.contains(item))! {
                return false
            }
        }
        
        return true // no matches found
    }
    
    // Checks if product is edible considering Users' allergans
    // ISSUE - has to be the exact word used, check strings directly incase it contains
    // ex. Restriction = "nuts" , Ingredients= "Soy Nut": goes undetected
    func isEdible() -> Bool {
        for allergen in preferences.urAllergens {
            if (product.ingredients?.contains(allergen.lowercased()))! {
                return false
            }
        }
        return true
    }

// Label Setters
    func setVeganAlert() {
        veganLabel.isHidden = false
        veganCheck.isHidden = false
        
        if !isVegan() {
            veganLabel.text = "Vegan"
            veganLabel.textColor = UIColor.red
            veganCheck.image = #imageLiteral(resourceName: "redX")
        }
    }
    
    func setVeggieAlert() {
        veggieLabel.isHidden = false
        veggieCheckbox.isHidden = false
        
        if !isVegetarian() {
            veggieLabel.text = "Vegetarian"
            veggieLabel.textColor = UIColor.red
            veggieCheckbox.image = #imageLiteral(resourceName: "redX")
        }
    }
    
    func setAllergenAlert() {
        allergensLabel.isHidden = false
        allergensCheck.isHidden = false
        
        if !isEdible() {
            allergensLabel.text = "Your Diet DOESN'T Allow!"
            allergensLabel.textColor = UIColor.red
            allergensCheck.image = #imageLiteral(resourceName: "redX")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
