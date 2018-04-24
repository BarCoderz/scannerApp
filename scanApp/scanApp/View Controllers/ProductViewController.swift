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

    @IBOutlet weak var ProductImageView: UIImageView!
    @IBOutlet weak var ProductNameLabel: UILabel!
    var imageURL: URL!
    
    @IBOutlet weak var veganLabel: UILabel!
    @IBOutlet weak var veganCheck: UIImageView!
    
    @IBOutlet weak var veggieLabel: UILabel!
    @IBOutlet weak var veggieCheckbox: UIImageView!
    
    @IBOutlet weak var allergensLabel: UILabel!
    @IBOutlet weak var allergensCheck: UIImageView!
    
    var product: FoodProduct!
    var preferences: Preference!
    
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
        
        if preferences.uVegan {
            setVeganAlert()
        }
        
        if preferences.uVegetarian {
           setVeggieAlert()
        }
        
        if preferences.urAllergens != nil {
           setAllergenAlert()
        }
    }
    
    //  Checks if product is considered Vegan
    func isVegan() -> Bool {
       /* for item in product.labels {
            if ((item.range(of: "vegan")) != nil) {
                return true
            } else {
                // check ingredients vs. non-vegan array                                                                                                                                                             
                // if match made, return false
                // else return true
         }
        } */ // ISSUE: FoodProduct.label, is one long string needs to be parsed into array
        return false
    }
    
    // Checks if product is considered Vegetarian - NOT COMPLETE
    func isVegetarian() -> Bool  {
        if (isVegan()) {
            return true
        }
        
        if ((product.labels.range(of: "vegetarian")) != nil) {
            return true
        } else {
            // check ingredients vs. non-vegtarian array
            // if match made, return false
            // else return true
        }
        return false
    }
    
    // Checks if product is edible considering Users' allergans
    func isEdible() -> Bool {
        for allergen in preferences.urAllergens {
            for ingredient in product.ingredients! {
                if ((ingredient.range(of: allergen)) != nil) {
                    return false
                }
            }
        }
        return true
    }
    
    func setVeganAlert() {
        veganLabel.isHidden = false
        veganCheck.isHidden = false
        
        if !isVegan() {
            veganLabel.textColor = UIColor.red
            veganCheck.image = #imageLiteral(resourceName: "redX")
        }
    }
    
    func setVeggieAlert() {
        veggieLabel.isHidden = false
        veggieCheckbox.isHidden = false
        
        if !isVegetarian() {
            veggieLabel.textColor = UIColor.red
            veggieCheckbox.image = #imageLiteral(resourceName: "redX")
        }
    }
    
    func setAllergenAlert() {
        allergensLabel.isHidden = false
        allergensCheck.isHidden = false
        
        if !isEdible() {
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
