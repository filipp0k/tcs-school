//
//  ViewController.swift
//  tcs-school
//
//  Created by Филипп Дюдин on 20.02.17.
//  Copyright © 2017 Филипп Дюдин. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let currencies = ["RUB", "USD", "EUR"]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = "Здесь будет курс"
        
        self.pickerFrom.dataSource = self
        self.pickerTo.dataSource = self
        self.pickerFrom.delegate = self
        self.pickerTo.delegate = self
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pickerFrom: UIPickerView!
    @IBOutlet weak var pickerTo: UIPickerView!
    @IBOutlet weak var label: UILabel!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

