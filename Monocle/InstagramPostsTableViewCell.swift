//
//  InstagramPostsTableViewCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/6/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class InstagramPostsTableViewCell: UITableViewCell {
    
    @IBOutlet var profileimageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var postImageView: UIImageView!
    
    
    
    var media: Instagram.Media! {
        didSet {
           configTableView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configTableView() {
        profileimageView.setImageWith(URL(string: media.avatarURL)!)
        nameLabel.text = media.username
        postImageView.setImageWith(URL(string: media.takenPhoto)!)
    }
    
}
