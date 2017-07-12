//
//  ViewController.swift
//  LiveBank
//
//  Created by admin on 7/7/17.
//  Copyright © 2017 xxx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.initView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initView() {
        // hide navigation bar
        // round background view
        // round button
        // focus on username field
        self.navigationController?.setNavigationBarHidden(true, animated: false);
        
        self.roundView.layer.cornerRadius = 10.0
        self.roundView.clipsToBounds = true
        
        self.loginButton.backgroundColor = UIColor(red: 0, green: 1, blue: 0.655, alpha: 1.0)
        self.loginButton.layer.cornerRadius = 5.0
        self.loginButton.layer.borderWidth = 0.0;
        self.loginButton.layer.borderColor = UIColor.black.cgColor
        
        self.usernameField.becomeFirstResponder()
    }

    
    @IBAction func login(_ sender: Any) {
        self.performSegue(withIdentifier:"home", sender: sender)
    }
}

