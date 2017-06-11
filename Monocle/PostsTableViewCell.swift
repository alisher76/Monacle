//
//  PostsTableViewCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/11/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var postCaption: UILabel!
    
    
    var media: Instagram.Media? {
        didSet {
            if let setMedia = media {
                postCaption.text = setMedia.caption
                likes.text = "❤️" + String(setMedia.likes) + " likes"
                if let url = URL(string: setMedia.takenPhoto) {
                    photo.setImageWith(url)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
