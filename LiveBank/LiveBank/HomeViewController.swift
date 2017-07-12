//
//  HomeViewController.swift
//  LiveBank
//
//  Created by admin on 7/8/17.
//  Copyright © 2017 xxx. All rights reserved.
//

import UIKit
import SwiftHTTP

class HomeViewController: UIViewController {
    
    lazy var banks:Array<Any> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initModel()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // try to get balance info from your bank
        
    }
    
    func initModel() {
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
                            let bank0 = banks[0] as! Dictionary<String, Any>
                            let balance = bank0["balance"] as? String
                            let doubleBalance = Double(balance!)
                            print(doubleBalance)
//                            self.banks.removeAll()
//                            self.banks = banks
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
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

}
