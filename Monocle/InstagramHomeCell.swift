//
//  InstagramHomeCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/5/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class InstagramHomeCell: UITableViewCell {

    @IBOutlet var profileImageVIew: UIImageView!
    @IBOutlet var profileNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    
    var userCollection: InstagramUser! {
        didSet {
            configTableViewCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    
    
    }
    
    func configTableViewCell() {
        
        profileImageVIew.setImageWith(URL(string: userCollection.image)!)
        profileNameLabel.text = userCollection.username
        descriptionLabel.text = userCollection.token
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
