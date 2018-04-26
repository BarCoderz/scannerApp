//
//  ScannerViewController.swift
//  scanApp
//
//  Created by student on 4/23/18.
//  Copyright © 2018 Angel Chara'e Mitchell. All rights reserved.
//

import UIKit
import BarcodeScanner

class ScannerViewController: UIViewController,
    BarcodeScannerCodeDelegate, BarcodeScannerErrorDelegate, BarcodeScannerDismissalDelegate,
    UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var tagCollection: UICollectionView!
    @IBOutlet weak var submitBtn: UIButton!
    
    var commonAllergens = ["Peanuts", "Bananas", "Soy", "Chocolate", "Wheat"]
    var allergens: [String] = []
    var profile: Preference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tagCollection.delegate = self
        tagCollection.dataSource = self
        profile = Preference()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func veganSwitch(_ sender: UISwitch) {
        if (sender.isOn) {
            profile.uVegan = true
            print("This session is VEGAN")
        } else {
            profile.uVegan = false
            print("This session is NOT VEGAN")
        }
    }
    
    @IBAction func vegSwitch(_ sender: UISwitch) {
        if (sender.isOn) {
            profile.uVegetarian = true
            print("This session is VEGETARIAN")
        } else {
            profile.uVegetarian = false
            print("This session is NOT VEGETARIAN")
        }
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return commonAllergens.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return commonAllergens[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.textField.text = self.commonAllergens[row]
        self.dropDown.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.textField {
            self.dropDown.isHidden = false
            //if you dont want the users to see the keyboard type:
            textField.endEditing(true)
        }
    }
    
    @IBAction func submitTag(_ sender: Any) {
        addTags()
    }
    
    func addTags() {
        let tag = textField.text
        allergens.append(tag!)
        textField.text = nil
        tagCollection.reloadData()
        
        // add allergens to perfence instance (profile)
        profile.urAllergens = self.allergens
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allergens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagCollection.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagCell
        cell.tagLabel.text = allergens[indexPath.row]
        
        return cell
    }
    
// Scan Functions
    
    @IBOutlet var startScanBtn: UIButton!
    var newProduct: FoodProduct!
    
    
    @IBAction func toPresentScan(_ sender: Any, forEvent event: UIEvent) {
        let viewController = makeBarcodeScannerViewController()
        viewController.title = "Barcode Scanner"
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func makeBarcodeScannerViewController() -> BarcodeScannerViewController {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        return viewController
    }
    
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        print("Barcode Data: \(code)")
        print("Symbology Type: \(type)")
        
        APIManager().getProduct(barcode: code) { (food: FoodProduct?, error: Error?) in
            if let food = food {
                self.newProduct = food
                if (food.completion) {
                    print(food.productName)
                    
                    // if product found, go to product view
                    self.performSegue(withIdentifier: "toProduct", sender: nil)
                } else {
                    print("no product found")
                    controller.resetWithError()
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if (self.newProduct != nil) {
                controller.reset()
                self.newProduct = nil
            } else {
                controller.resetWithError()
                self.newProduct = nil
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! ProductViewController
        destinationViewController.product = newProduct
        destinationViewController.preferences = profile
    }
    
    
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
    
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

