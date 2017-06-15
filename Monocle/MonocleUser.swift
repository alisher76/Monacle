//
//  MonocleUser.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/14/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation

class MonocleUser {
    let name: String
    let userName: String
    let twitterID: String?
    var instagramID: String?
    let profileImage: String
    var accounts: [MonocolAccount]?
    let posts: [MonoclePost]?
    
    init(name: String, userName: String, twitterID: String, instagramID: String, profileImage: String, accounts: [MonocolAccount], posts: [MonoclePost]) {
        self.name = name
        self.userName = userName
        self.twitterID = twitterID
        self.instagramID = instagramID
        self.profileImage = profileImage
        self.accounts = accounts
        self.posts = posts
    }
    
    
}


