//
//  LikedTweetCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/11/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class LikedTweetCell: TweetLikesTableViewCell {

    override func awakeFromNib() {
        super .awakeFromNib()
        
        //Initilization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    override func tweetSetConfigure() {
        super.tweetSetConfigure()
        
        retweetCountTabel.text = tweet.retweetsCount > 0 ? String(tweet.retweetsCount) : ""
        favoriteCountLabel.text = tweet.favoriteCount > 0 ? String(tweet.favoriteCount) : ""
    }


}
