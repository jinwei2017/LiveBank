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
    
    var banks:Array<Any> = []
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var availableBalanceLabel: UILabel!
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initModel()
        initView()
        refreshViewWith(Banks: banks)
        
        // Update your balance
        refresh(sender: self)
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
        banks.removeAll()
    }
    
    func initView() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Updating your balance...",
                                                            attributes: [NSForegroundColorAttributeName: UIColor.white])
        refreshControl.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        scrollView.addSubview(refreshControl)
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
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                    }
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
                                self.refreshControl.endRefreshing()
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                            DispatchQueue.main.async {
                                self.refreshControl.endRefreshing()
                            }
                            return
                        }
                    }
                }
            }
        } catch let error {
            print("got an error creating the request: \(error)")
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            return
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
