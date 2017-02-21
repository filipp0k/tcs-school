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
        if pickerView == pickerTo {
            return self.currenciesExceptBase().count
        }
        return currencies.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerTo {
            return self.currenciesExceptBase()[row]
        }
        return currencies[row]
    }
    
    func requestCurrenciesRates(baseCurrency: String, parseHandler: @escaping (Data?, Error?) -> Void){
        let url = URL(string: "https://api.fixer.io/latest?base=" + baseCurrency)!
        
        let dataTask = URLSession.shared.dataTask(with: url){
            (dataRecieved, response, error) in
            parseHandler(dataRecieved, error)
        }
        
        dataTask.resume();
    }
    
    func parseCurrencyRatesResponse(data: Data?, toCurrency: String?) -> String {
        var value : String = ""
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String, Any>
            if let parsedJSON = json
            {
                print("\(parsedJSON)")
                if let rates = parsedJSON["rates"] as? Dictionary<String, Double>
                {
                    if let rate = rates[toCurrency!] { value = "\(rate)" }
                    else { value = "No rate for currency \"\(toCurrency)\" found" }
                } else { value = "No \"rates\" found" }
            }
            else { value = "No JSON value parsed" }
        } catch { value = error.localizedDescription }
        return value
    }
    
    func retieveCurrencyRate(baseCurrency: String, toCurrency: String, completion: @escaping (String) -> Void) {
        self.requestCurrenciesRates(baseCurrency: baseCurrency) {
            [weak self] (data, error) in
            var string = "No currency retrieved!"
            
            if let currentError = error {
                string = currentError.localizedDescription
            } else {
                if let strongSelf = self {
                    string = strongSelf.parseCurrencyRatesResponse(data: data, toCurrency: toCurrency)
                }
            }
            completion(string)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = "Здесь будет курс"
        self.activityIndicator.hidesWhenStopped = true
        self.pickerFrom.dataSource = self
        self.pickerTo.dataSource = self
        self.pickerFrom.delegate = self
        self.pickerTo.delegate = self
        self.requestCurrenciesRates(baseCurrency: "USD") {
            (data, error) in
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let baseCurrencyIndex = self.pickerFrom.selectedRow(inComponent: 0)
        let toCurrencyIndex = self.pickerTo.selectedRow(inComponent: 0)
        let baseCurrency = self.currencies[baseCurrencyIndex]
        let toCurrency = self.currencies[toCurrencyIndex]
        self.retieveCurrencyRate(baseCurrency: baseCurrency, toCurrency: toCurrency) {
            [weak self] (value) in
            DispatchQueue.main.async {
                if let strongSelf = self {
                    strongSelf.label.text = value
                }
            }
        }
        if pickerView == pickerFrom {
            self.pickerTo.reloadAllComponents()
        }
    }
    func currenciesExceptBase() -> [String] {
        var currenciesExceptBase = currencies
        currenciesExceptBase.remove(at: pickerFrom.selectedRow(inComponent: 0))
        
        return currenciesExceptBase
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

