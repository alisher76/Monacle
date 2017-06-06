//
//  FriendsTVCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/5/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class FriendsTVCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var userName: UILabel!
    @IBOutlet var imageViewOutlet: UIImageView!
    
    var user: TwitterUser! {
        didSet {
            tvcFriendsListSetConfigure()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    func tvcFriendsListSetConfigure() {
    
        nameLabel.text = user.name
        userName.text = "@\(user.screenName)"
        imageViewOutlet.setImageWith(URL(string: user.image)!)
    }

}
