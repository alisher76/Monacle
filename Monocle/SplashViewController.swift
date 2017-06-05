//
//  SplashViewController.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/3/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController, TwitterLoginDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
       TwitterClient.sharedInstance?.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if(!appDelegate.splashDelay) {
            delay(delay: 1.0, closure: { 
                self.continueLogin()
            })
        }
        
    }
    
    
    func continueLogin() {
       appDelegate.splashDelay = false
        if User.currentUser == nil {
            self.goToLogin()
        }else{
            self.goToApp()
        }
    }
    
    func goToLogin() {
        self.performSegue(withIdentifier: "loginSegue", sender: self)
    }
    
    func goToApp() {
        self.performSegue(withIdentifier: "showApp", sender: self)
    }

   
}
