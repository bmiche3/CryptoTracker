//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Benny Michel on 5/29/18.
//  Copyright © 2018 Benny Michel. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cryptoArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cryptoArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(cryptoArray[row])
        appendedFeed = feed + cryptoArray[row] + "USD"
        getCryptoData(url: appendedFeed)
    }
    
    let feed = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    var appendedFeed = ""
    let cryptoArray = ["BTC", "LTC", "ETH", "XRP", ]
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    
    @IBOutlet weak var cryptoPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cryptoPicker.delegate = self
        cryptoPicker.dataSource = self
        pickerView(cryptoPicker, didSelectRow: 0, inComponent: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getCryptoData(url: String) {
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    print("data received")
                    let cryptoJSON : JSON = JSON(response.result.value!)
                    
                    self.updateCryptoData(json: cryptoJSON)
                    
                } else {
                    print( "error")
                }
        }
    }
    
    func updateCryptoData(json : JSON){
        if let cryptoPrice = json["ask"].double {
            priceLabel.text = "$" + String(cryptoPrice)
        } else {
            priceLabel.text = "Error"
        }
        
        if let dayDiff = json["changes"]["price"]["day"].double{
            dayLabel.text = "$" + String(dayDiff)
        } else {
            dayLabel.text = "Error"
        }
        if let weekDiff = json["changes"]["price"]["week"].double{
            weekLabel.text = "$" + String(weekDiff)
        } else {
            weekLabel.text = "Error"
        }
        if let monthDiff = json["changes"]["price"]["month"].double{
            monthLabel.text = "$" + String(monthDiff)
        } else {
            monthLabel.text = "Error"
        }
        if let volume = json["volume"].double{
            volumeLabel.text = String(volume)
        } else {
            monthLabel.text = "Error"
        }
    }

}


