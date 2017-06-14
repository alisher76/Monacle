//
//  TweetLikesTableViewCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/11/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class TweetLikesTableViewCell: UITableViewCell {

    
    weak var delegate: TwitterTableViewDelegate?
    @IBOutlet var authorUserNameLabel: UILabel!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var profilePicImageView: UIImageView!
    
    @IBOutlet var mediaImageVerticalSpacingConstraint: NSLayoutConstraint!
    @IBOutlet var mediaImageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet var retweetCountTabel: UILabel!
    @IBOutlet var tweetContentsLabel: UILabel!
    @IBOutlet var favoriteCountLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    
    var friends: [TwitterUser] = []
    var indexPath: IndexPath!
    
    var tweetID: Int!
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
        profilePicImageView.setImageWith(tweet.authorProfilePic! as URL)
        profilePicImageView.layer.cornerRadius = 5
        profilePicImageView.clipsToBounds = true
        authorNameLabel.text = tweet.author
        authorUserNameLabel.text = "@" + tweet.screenName!
        
        tweetContentsLabel.text = tweet.text
        
        let urls = tweet.urls
        let media = tweet.media
        var displayURLS = [String]()
        
        mediaImageView.image = nil
        
        if let urls = urls {
            for _url in urls {
                let urlText = _url["url"] as! String
                tweetContentsLabel.text = tweetContentsLabel.text?.replcae(target: urlText, withString: "")
                
                
                var displayURL = _url["display_url"] as! String
                if let expancedURL = _url["expanded_url"] {
                    displayURL = expancedURL as! String
                }
                displayURLS.append(displayURL)
            }
            
        }
        
        if let media = media {
            for medium in media {
                
                let urltext = medium["url"] as! String
                tweetContentsLabel.text = tweetContentsLabel.text?.replcae(target: urltext, withString: " ")
                if((medium["type"] as? String) == "photo") {
                    
                    displayPhoto()
                    
                    let mediaurl = medium["media_url_https"] as! String
                    mediaImageHeightConstraint.isActive = false
                    
                    mediaImageView.layer.cornerRadius = 5
                    mediaImageView.clipsToBounds = true;
                    mediaImageView.setImageWith(URLRequest(url: URL(string: mediaurl)!), placeholderImage: nil, success: { (request, response, image) -> Void in
                        // success
                        self.mediaImageView.image = image
                        self.delegate?.reloadTableCellAtIndex(self, indexPath: self.indexPath)
                    }, failure: { (request, response, error) -> Void in
                        // error
                    });
                }
            }
        }
        
        if displayURLS.count > 0 {
            
            
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
    
    func displayPhoto() {
        self.mediaImageVerticalSpacingConstraint.constant = 8
        self.mediaImageView.isHidden = false
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
