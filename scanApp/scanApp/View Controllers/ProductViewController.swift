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
    
    var product: FoodProduct!
    var preferences: Preference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProductNameLabel.text = product.productName
        imageURL = product.image_url

        if imageURL != nil{
            ProductImageView .af_setImage(withURL: imageURL)
        }
        
        // Do any additional setup after loading the view.
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
