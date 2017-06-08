//
//  User.swift
//  twitter
//
//  Created by Josh Lubaway on 2/21/15.
//  Copyright (c) 2015 Frustrated Inc. All rights reserved.
//
import UIKit

class User {
    
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
    }
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            if (_currentUser == nil) {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUser") as? Data
                
                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUser")
            } else {
                defaults.set(nil, forKey: "currentUser")
            }
        }
    }
    
    class Friends {
        var dictionary: [String]?
        
        init(dictionary: [String]) {
            self.dictionary = dictionary
        }
        
        static var _currentListOfFriends: User.Friends?
        
        class var currentListOfFriends: User.Friends? {
            get {
                if (_currentListOfFriends == nil) {
                    let defaults = UserDefaults.standard
                    let userData = defaults.object(forKey: "savedListOfFriends") as? Data
                    
                    if let userData = userData {
                        let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String]
                        
                        _currentListOfFriends = User.Friends(dictionary: dictionary)
                    }
                }
                return _currentListOfFriends
            }
            
            set(userFriends) {
                _currentListOfFriends = userFriends
                
                let defaults = UserDefaults.standard
                
                if let userFriend = userFriends {
                    let data = try! JSONSerialization.data(withJSONObject: userFriend.dictionary!, options: [])
                    defaults.set(data, forKey: "savedListOfFriends")
                } else {
                    defaults.set(nil, forKey: "savedListOfFriends")
                }
            }
        }
    }
}
