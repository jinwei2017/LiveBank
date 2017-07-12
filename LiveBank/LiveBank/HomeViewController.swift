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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        balance()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func balance() {
        do {
            let opt = try HTTP.GET("https://api.teller.io/accounts", headers: ["Authorization": "Bearer MUHWENYT5BZHWJERCTFN3KMJ74TUWPLNE3BOAB6KGUWDHRF4EMDPR7HJNQFZ5LYF"])
            opt.start { response in
                if let err = response.error {
                    print("error: \(err.localizedDescription)")
                    return //also notify app of failure as needed
                }
                print("opt finished: \(response.description)")
                //print("data is: \(response.data)") access the response of the data with response.data
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
