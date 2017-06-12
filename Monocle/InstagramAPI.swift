//
//  InstagramAPI.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/6/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Instagram {
   
   let client_id = "ac00ba2a3ad64cc8b4a180dcc5869e49"
    
  struct Media {
    var takenPhoto: String
    var uid: String
    var username: String
    var avatarURL: String
    var caption: String
    var comments: [Comment]
    var time: Int
    var likes: Int
    }
    
    struct Comment {
        let fromUserName: String
        let text: String
    }
    
    
    // Turn friends list data into needed Type
    func populateFriendsList(_ data: Any?, callback: ([InstagramUser]) -> Void) {
        let json = JSON(data!)
        var users = [InstagramUser]()
        for _user in json["data"].arrayValue {
            let user = InstagramUser(fullName: _user["full_name"].stringValue, userName: _user["username"].stringValue, uid: _user["id"].stringValue, image: _user["profile_picture"].stringValue)
            users.append(user)
        }
        callback(users)
    }
    
    //Get user lists data
    func fetchUserFriends(_ accessToken: String, callBack: @escaping ([InstagramUser]) -> Void) {
        request("https://api.instagram.com/v1/users/self/follows?access_token=\(accessToken)", method: .get).responseJSON { (responce) in
            self.populateFriendsList(responce.result.value, callback: callBack)
        }
    }
    // Turn media Data into needed type
    func populateFriendsRecentPosts(_ data: Any?, callback: ([Media]) -> Void) {
    
        let json = JSON(data!)
        var medias = [Media]()
        
        for _media in json["data"].arrayValue {
            var comments = [Comment]()
            for comment in _media["comments"]["data"].arrayValue {
                comments.append(Comment(fromUserName: comment["from"]["username"].stringValue, text: comment["text"].stringValue))
            }
            
           medias.append(Media(takenPhoto: _media["images"]["standard_resolution"]["url"].stringValue, uid: _media["user"]["id"].stringValue, username: _media["user"]["username"].stringValue, avatarURL: _media["user"]["profile_picture"].stringValue, caption: _media["caption"]["text"].stringValue, comments: comments, time: _media["created_time"].intValue, likes: _media["item"]["count"].intValue))
        }
        callback(medias)
    }
    
    // Get user media Data
    
    func fetchRecentMediaForUser(_ id: String, accessToken: String, callback: @escaping ([Media]) -> Void) {
        request("https://api.instagram.com/v1/users/\(id)/media/recent/?access_token=\(accessToken)", method: .get).responseJSON { (responce) in
            self.populateFriendsRecentPosts(responce.result.value, callback: callback)
        }
      }
    
    // https://api.instagram.com/v1/users/self/media/liked?access_token=ACCESS-TOKEN

    func fetchRecentLikesForUser(_ id: String, accessToken: String, callback: @escaping ([Media]) -> Void) {
        request("https://api.instagram.com/v1/users/\(id)/media/liked?access_token=\(accessToken)", method: .get).responseJSON { (responce) in
            self.populateFriendsRecentPosts(responce.result.value, callback: callback)
        }
    }
}
