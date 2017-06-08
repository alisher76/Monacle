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
    
    @IBAction func twitterButtonTaped(_ sender: Any) {
        TwitterClient.sharedInstance?.login(success: {
            print("Logged In")
            self.dismiss(animated: true, completion: {
                
            })
        }) { (error) in
            print(error)
        }
    }
    
    func continueLogin() {
       appDelegate.splashDelay = false
        if User.currentUser != nil && User.Friends.currentListOfFriends == nil {
            self.goToSelectFriendsPage()
        }else if User.currentUser != nil && User.Friends.currentListOfFriends != nil{
            self.goToApp()
        }
    }
    
    func goToSelectFriendsPage() {
        self.performSegue(withIdentifier: "selectFriends", sender: self)
    }
    
    func goToApp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "twitterHomePage") as! HomeTableViewController
        if let savedData = UserDefaults.standard.array(forKey: "savedListOfFriends"){
            vc.friendIDs = savedData as? [String]
        }
        self.performSegue(withIdentifier: "showApp", sender: self)
        
    }
    
    

   
}
