//
//  InstagramUser.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/10/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation

class InstagramUser {
    var fullName: String
    var userName: String
    var uid: String
    var image: String
   


init(fullName: String, userName: String, uid: String, image: String) {
    self.fullName = fullName
    self.userName = userName
    self.uid = uid
    self.image = image
}

convenience init?(json: NSDictionary) {
    guard let fullName = json[InstagramUser.fullNameKey] as? String,
        let userName = json[InstagramUser.userNameKey] as? String,
        let uid = json[InstagramUser.uidKey] as? String,
        let image = json[InstagramUser.imageKey] as? String
        else {
            return nil
    }
    self.init(fullName: fullName, userName: userName, uid: uid, image: image)
}

static func array(json: [NSDictionary]) -> [InstagramUser]? {
    var converted = [InstagramUser]()
    for i in json {
        guard let user = InstagramUser(json: i) else { return nil }
        converted.append(user)
    }
    return converted
}

static var fullNameKey: String = "full_name"
static var userNameKey: String = "username"
static var uidKey: String = "id"
static var imageKey: String = "profile_picture"



}
