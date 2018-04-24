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
    
    var tags: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagCollection.delegate = self
        tagCollection.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        //self.dropDown.isHidden = true
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
        tags.append(tag!)
        textField.text = nil
        print(tags.count)
        tagCollection.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = tagCollection.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! TagCell
        cell.tagLabel.text = tags[indexPath.row]
        
        return cell
    }
    
// Scan function
    
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

