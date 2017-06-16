//
//  AppDelegate.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/3/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var splashDelay = false
    var firstSignIn = true

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Change the color of tab bar items
        
        UITabBar.appearance().tintColor = UIColor.black
        
        let INSTAGRAM_CLIENT_ID = "ac00ba2a3ad64cc8b4a180dcc5869e49"
        let INSTAGRAM_REDIRECT_URI = "http://localhost//comeOnBroApp"
        
        let auth: NSMutableDictionary = ["client_id": INSTAGRAM_CLIENT_ID,
                                         SimpleAuthRedirectURIKey: INSTAGRAM_REDIRECT_URI]
        SimpleAuth.configuration()["instagram"] = auth

        return true
    }

    open func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        TwitterClient.sharedInstance?.handleOpenURL(url: url)
        return true
    }


}


func delay(delay:Double, closure: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        closure()
    }
}

extension String {
    func replcae(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: .literal, range: nil)
    }
}
