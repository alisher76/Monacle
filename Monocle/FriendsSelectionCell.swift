//
//  FriendsSelectionCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/7/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class FriendsSelectionCell: UITableViewCell {

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
        nameLabel.sizeToFit()
        userName.text = "@\(user.screenName)"
        userName.sizeToFit()
        imageViewOutlet.setImageWith(URL(string: user.image)!)
    }
}
