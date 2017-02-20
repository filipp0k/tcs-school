//
//  ViewController.swift
//  tcs-school
//
//  Created by Филипп Дюдин on 20.02.17.
//  Copyright © 2017 Филипп Дюдин. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = "Здесь будет курс"
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

