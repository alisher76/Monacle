//
//  CommentTableViewCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/10/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var comments: UILabel!
    
    var comment: Instagram.Comment? {
        didSet {
            guard let setComment = comment else {
                return
            }
            
            let line = setComment.fromUserName + ": " + setComment.text
            let attributedString = NSMutableAttributedString(string: line)
            let range = (line as NSString).range(of: setComment.fromUserName)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blue, range: range)
            comments.attributedText = attributedString
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
