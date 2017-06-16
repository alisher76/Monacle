//
//  SplashViewController.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/3/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import SwiftyJSON

class SplashViewController: UIViewController, TwitterLoginDelegate {
    
    
    var delegate: HomeTableViewController?
    let userDefaults = UserDefaults.standard
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var accessToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       TwitterClient.sharedInstance?.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        
    }
    
    @IBAction func instagramButtonTapped(_ sender: Any) {
        
        goToInstaApp()    
    }
    
    
    @IBAction func twitterButtonTaped(_ sender: Any) {
        continueLogin()
        
    }
    
    func continueLogin() {
        let accessToken = userDefaults.object(forKey: "accessToken") as? String
        let savedUsers = userDefaults.object(forKey: "savedFriends") as? [NSDictionary]
        
        if savedUsers == nil {
            self.goToSelectFriendsPage()
        }else if accessToken != nil && savedUsers != nil {
            self.goToApp()
        }else{
        
            TwitterClient.sharedInstance?.login(success: {
                print("Logged In")
                self.dismiss(animated: true, completion: {
                self.goToSelectFriendsPage()
                    
                })
            }) { (error) in
                print(error)
            }
        }
    }
    
    func goToSelectFriendsPage() {
        self.performSegue(withIdentifier: "selectFriends", sender: self)
    }
    
    func goToInstaApp() {
        
        let accessToken = userDefaults.object(forKey: "accessTokenForInstagram") as? String
        let savedUsers = userDefaults.object(forKey: "savedInstagramFriends") as? [NSDictionary]
        
        
        if accessToken == nil  && savedUsers == nil {
           self.performSegue(withIdentifier: "showListOfFriendsInstagram", sender: self)
        }else if accessToken != nil && savedUsers != nil{
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "InstagramHomePageController")
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
           
        }
    }

    func goToApp() {
        
        self.performSegue(withIdentifier: "showApp", sender: self)
    }
    
    func reloadData(appending: Bool = false)  {
        
        TwitterClient.sharedInstance?.getHomeTimeline(success: { (tweets) in
            
            
        }, failure: { (error) in
            print(error)
        })
        
    }
    
}
