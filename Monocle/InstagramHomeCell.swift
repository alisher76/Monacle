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
    
   
    var user: Instagram.User! {
        didSet {
            configTableViewCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    
    
    }
    
    func configTableViewCell() {
        OperationQueue.main.addOperation {
            self.profileImageVIew.setImageWith(URL(string: self.user.image)!)
            self.profileNameLabel.text = self.user.name
            self.descriptionLabel.text = self.user.userName
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
