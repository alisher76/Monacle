//
//  HeaderTableViewCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/10/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit



class HeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var headPic: UIImageView!
    @IBOutlet weak var headUserName: UILabel!
    @IBOutlet weak var headTime: UILabel!
    
    
    var header: Instagram.Media? {
        didSet {
            
            
               // self.headUserName.textColor = UIColor(red: 20.0/255.0, green: 85.0/255.0, blue: 135.0/255.0, alpha: 1.0)
                
//                let timeInterval = Double(setHeader.time)
//                let date = NSDate(timeIntervalSince1970: timeInterval)
//                let stringTime = instanceDate.shortTimeAgoSinceDate(date)
//                self.headTime.text = stringTime
            }
    }
    
    func updateUI() {
        headPic.layer.borderWidth = 1
        headPic.layer.masksToBounds = true
        headPic.layer.borderColor = UIColor.black.cgColor
        headPic.layer.cornerRadius = self.headPic.bounds.width / 2.0
        headPic.clipsToBounds = true
        headUserName.text = header?.username
        if let url = header?.avatarURL {
            self.headPic.setImageWith(URL(string: url)!)
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
