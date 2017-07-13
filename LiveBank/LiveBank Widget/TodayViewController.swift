//
//  TodayViewController.swift
//  LiveBank Widget
//
//  Created by admin on 7/8/17.
//  Copyright © 2017 xxx. All rights reserved.
//

import UIKit
import NotificationCenter
import SwiftHTTP

class TodayViewController: UIViewController, NCWidgetProviding {
    
    var banks:Array<Any> = []
    
    @IBOutlet weak var availableBalanceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view from its nib.
        initModel()
        refreshViewWith(Banks: banks)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        refresh(sender: self)
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func initModel() {
        banks.removeAll()
    }
    
    func refreshViewWith(Banks banks: Array<Any>) {
        var balance = 0.0
        
        if banks.count > 0 {
            let bank = banks.first as! Dictionary<String, Any>
            let balanceString = bank["balance"] as! String
            balance = Double(balanceString)!
        }
        
        availableBalanceLabel.text = "£\(balance)"
    }
    
    func refresh(sender:AnyObject) {
        // teller api calls to update your balance
        apiBanks()
    }

    func apiBanks() {
        do {
            let opt = try HTTP.GET("https://api.teller.io/accounts",
                                   headers: ["Authorization": "Bearer MUHWENYT5BZHWJERCTFN3KMJ74TUWPLNE3BOAB6KGUWDHRF4EMDPR7HJNQFZ5LYF"])
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return
                }
                
                if let text = response.text {
                    print("response: \(text)")
                    
                    if let data = text.data(using: .utf8) {
                        do {
                            let banks = try JSONSerialization.jsonObject(with: data, options: []) as! Array<Any>
                            
                            self.banks.removeAll()
                            self.banks = banks
                            
                            DispatchQueue.main.async {
                                self.refreshViewWith(Banks: banks)
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                            return
                        }
                    }
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            return
        }
    }

}
