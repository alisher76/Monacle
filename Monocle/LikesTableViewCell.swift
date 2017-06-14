//
//  LikesTableViewCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/11/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class LikesTableViewCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var postCaption: UILabel!
    @IBOutlet var profileImageHeader: UIImageView!
    
    var user: InstagramUser? {
        didSet {
            if let setUser = user {
                nameLabel.text = setUser.fullName
            }
        }
    }
    
    var media: Media? {
        didSet {
            if let setMedia = media {
                postCaption.text = setMedia.caption
                likes.text = "❤️" + String(setMedia.likes) + " likes"
                if let url = URL(string: setMedia.takenPhoto) {
                    photo.setImageWith(url)
                }
                guard let urlAvatar = URL(string: (media?.avatarURL)!) else {return}
                self.profileImageHeader.setImageWith(urlAvatar)
                
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageHeader.layer.borderWidth = 1
        profileImageHeader.layer.masksToBounds = true
        profileImageHeader.layer.borderColor = UIColor.black.cgColor
        profileImageHeader.layer.cornerRadius = self.profileImageHeader.bounds.width / 2.0
        profileImageHeader.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
