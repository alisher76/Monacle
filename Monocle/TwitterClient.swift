//
//  TwitterClient.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/3/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    //OAuth = Fetch Request Token + redirect to auth + fetch access token + callback url
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "YJHFbPWaKlzWFW8MG1PFVBshS", consumerSecret: "HKco4y1pEpaupl2D3Vm4i1BG4CkhTCAVlJp5Q2cTsnsKuegZSL")
    
    //Getting request token to open up authorize link in safari
    var accessToken: String!
    var loginSuccess: (() ->())?
    var loginFailure: ((Error) ->())?
    weak var delegate: TwitterLoginDelegate?
    
    func login(success: @escaping () ->(), failure: @escaping (Error) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"monocle://success")!, scope: nil, success: { (requestToken) in
            print("Got token")
            
            let url = URL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=" + (requestToken?.token)!)!
            UIApplication.shared.open(url)
            
        }) { (error) in
            print("Error")
            self.loginFailure?(error!)
        }
    }
    
    //Get access token and save user
    func handleOpenURL(url: URL) {
        let  appDelegate = UIApplication.shared.delegate as! AppDelegate
       
        let userDefaults = UserDefaults.standard
        appDelegate.splashDelay = true
        
        //get access token
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)!
        
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken) in
            
                userDefaults.set(accessToken?.token, forKey: "accessToken")
                userDefaults.synchronize()
            
                self.loginSuccess?()
                self.delegate?.continueLogin()
           
                self.loginSuccess?()
        }) { (error) in
            self.loginFailure?(error!)
        }
    }
    
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        
        
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task, responce) in
            let userDict = responce as! NSDictionary
            let user = User(dictionary: userDict)
            success(user)
        }) { (task, error) in
            print(error.localizedDescription)
            failure(error)
        }
        
    }
    
    //Get hometimeline
    
    func getHomeTimeline(maxID: Int? = nil, success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        
        var params = ["count": 10]
        
        if (maxID != nil) {
            params["max_id"] = maxID
        }
        
        get("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (task, responce) in
            
            let dictionary = responce as! [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries: dictionary)
            success(tweets)
        }) { (task, error) in
            print(error.localizedDescription)
            failure(error as NSError)
        }
        
    }
    
    //Get FriendsList
    
    
    func getListOfFollowedFriends(success: @escaping ([TwitterUser]) -> (), failure: @escaping (NSError) -> ()) {
        
        let params = ["count": 10]
        
        get("1.1/friends/list.json", parameters: params, progress: nil, success: { (task, responce) in
            
            if let usersDictionary = responce as? [String:Any] {
                let anime = usersDictionary["users"] as? [NSDictionary]
                guard let user = TwitterUser.array(json: anime!) else {return}
                success(user)
                print(user.count)
            }
        }) { (task, error) in
            print(error.localizedDescription)
            
        }

    }
    
    
    //https://api.twitter.com/1.1/statuses/user_timeline.json
    
    func getUserTimeline(userID: String, success: @escaping ([Tweet]) -> (), failure: @escaping (NSError) -> ()) {
        
        let params = ["count": 10]
        
        get("1.1/statuses/user_timeline.json?user_id=\(userID)", parameters: params, progress: nil, success: { (task, responce) in
            
            let dictionary = responce as! [NSDictionary]
            let tweets = Tweet.tweetWithArray(dictionaries: dictionary)
            success(tweets)
        }) { (task, error) in
            print(error.localizedDescription)
            
        }
        
    }
    
    func logOut() {
        User.currentUser = nil
        deauthorize()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    
    
    
}
