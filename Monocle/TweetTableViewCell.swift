//
//  TweetTableViewCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/4/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

   @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var authorUserNameLabel: UILabel!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var profilePicImageView: UIImageView!
    
    @IBOutlet var retweetCountTabel: UILabel!
    @IBOutlet var tweetContentsLabel: UILabel!
    @IBOutlet var favoriteCountLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    
    var friends: [TwitterUser] = []
    
    var tweetID: NSNumber!
    var tweetTextFontSize: CGFloat { get { return 15.0 }}
    var tweetTextWeigth: CGFloat { get { return UIFontWeightRegular} }
    var tweet: Tweet! {
        didSet {
            tweetSetConfigure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    func tweetSetConfigure() {
        tweetID = tweet.tweetID
        profilePicImageView.setImageWith(tweet.authorProfilePic!)
        profilePicImageView.layer.cornerRadius = 5
        profilePicImageView.clipsToBounds = true
        
        authorNameLabel.text = tweet.author
        authorUserNameLabel.text = "@" + tweet.screenName!
        
        tweetContentsLabel.text = tweet.text
        var displayURLS = [String]()
        
        let media = tweet.media
        print(tweet.precedingTweetID)


        
        
        print(displayURLS.count)
        
        if(displayURLS.count > 0){
            
            let content = tweetContentsLabel.text ?? ""
            
            let urlText = " " + displayURLS.joined(separator: " ")
            
            let text = NSMutableAttributedString(string: content)
            
            text.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: tweetTextFontSize, weight: tweetTextFontSize), range: NSRange(location: 0, length: content.characters.count))
            
            let links = NSMutableAttributedString(string: urlText)
            links.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: tweetTextFontSize, weight: tweetTextFontSize), range: NSRange(location: 0, length: urlText.characters.count))
            
            links.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 36/255.0, green: 144/255.0, blue: 212/255.0, alpha: 1), range: NSRange(location: 0, length: urlText.characters.count))
            
            text.append(links)
            
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5
            style.lineBreakMode = .byCharWrapping
            text.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: text.string.characters.count))
            
            tweetContentsLabel.attributedText = text
            
        }
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func favoritedButtonTapped(_ sender: Any) {
        if tweet.favorited == false {
            favoriteCountLabel.text = String(tweet.favoriteCount)
        }else{
           favoriteCountLabel.text = String(tweet.favoriteCount)
        }
    }
    @IBAction func retweetButtonTapped(_ sender: Any) {
        if tweet.retweeted == false {
            retweetCountTabel.text = String(tweet.retweetsCount)
        }else{
        retweetCountTabel.text = String(tweet.retweetsCount)
        }
    }

}

