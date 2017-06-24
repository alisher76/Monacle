//
//  TweetTableViewCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/4/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import SAMCache

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet var instagramLogoOutlet: UIButton!
    @IBOutlet var twitterLogoOutlet: UIButton!
    @IBOutlet var authorUserNameLabel: UILabel!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var profilePicImageView: UIImageView!
    
    @IBOutlet var retweetCountTabel: UILabel!
    @IBOutlet var tweetContentsLabel: UILabel!
    @IBOutlet var favoriteCountLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet var mediaImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var mediaImageVerticalSpacingConstraint: NSLayoutConstraint!
    
    weak var delegate: TwitterTableViewDelegate?
    
    var homeDelegate: HomeTableViewController?
    var friends: [TwitterUser] = []
    var indexPath: IndexPath!
    
    var postID: Int!
    var tweetID: Int!
    var tweetTextFontSize: CGFloat { get { return 15.0 }}
    var tweetTextWeigth: CGFloat { get { return UIFontWeightRegular} }
    
    var tweet: Tweet! {
        didSet {
            
        }
    }
    
    var instaPost: Media! {
        didSet {
            
        }
    }
    var monoclePost: MonoclePost! {
        didSet {
            switch monoclePost {
            case .some(.tweet(let value)):
                tweet = value
                tweetSetConfigure()
                print(value)
            case .some(.instagram(let value)):
                 instaPost = value
                 instaPostSetConfigure()
                print(value)
            case .none:
                print("something went wrong")
            }
         }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func tweetSetConfigure() {
        
        instagramLogoOutlet.imageView?.image = UIImage(named: "InstagramLogo")
        twitterLogoOutlet.imageView?.image = UIImage(named: "Twitter Filled")
        tweetID = tweet.tweetID
        profilePicImageView.setImageWith(tweet.authorProfilePic! as URL)
        profilePicImageView.layer.cornerRadius = 5
        profilePicImageView.clipsToBounds = true
        authorNameLabel.text = tweet.author
        authorUserNameLabel.text = "@" + tweet.screenName!
        
        tweetContentsLabel.text = tweet.text
        
        var urls = tweet.urls
        var media = tweet.media {
            didSet {
                
            }
        }
        
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
        OperationQueue.main.addOperation {
            
        if let media = media {
            for medium in media {
                
                let urltext = medium["url"] as! String
                self.tweetContentsLabel.text = self.tweetContentsLabel.text?.replcae(target: urltext, withString: " ")
                if((medium["type"] as? String) == "photo") {
                    
                    let mediaurl = medium["media_url_https"] as! String
                    self.mediaImageHeightConstraint.isActive = false
                    self.mediaImageView.sizeToFit()
                    self.mediaImageView.layer.cornerRadius = 5
                    self.mediaImageView.clipsToBounds = true;
                    self.mediaImageView.setImageWith(URLRequest(url: URL(string: mediaurl)!), placeholderImage: nil, success: { (request, response, image) -> Void in
                        // success
                        self.mediaImageView.image = image
                        self.delegate?.reloadTableCellAtIndex(self, indexPath: self.indexPath)
                    self.displayPhoto()
                    }, failure: { (request, response, error) -> Void in
                        // error
                    });
                }
            }
        }
      }
        if displayURLS.count > 0 {
            
            
            let content = tweetContentsLabel.text ?? ""
            let urlText = "\n" + displayURLS.joined(separator: "")
            let text = NSMutableAttributedString(string: content)
            let links = NSMutableAttributedString(string: urlText)
            links.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 36/255.0, green: 144/255.0, blue: 212/255.0, alpha: 1), range: NSRange(location: 0, length: urlText.characters.count))
            text.append(links)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 5
            style.lineBreakMode = .byCharWrapping
            text.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSRange(location: 0, length: text.string.characters.count))
            
            tweetContentsLabel.attributedText = text
        }
        
    }
    
    
    
    func instaPostSetConfigure() {
        OperationQueue.main.addOperation {
        self.homeDelegate?.selectedPost = self.monoclePost
        self.postID = Int(self.instaPost.uid)
        self.profilePicImageView.setImageWith(URL(string: self.instaPost.avatarURL)!)
        self.profilePicImageView.layer.cornerRadius = 5
        self.profilePicImageView.clipsToBounds = true
        self.authorNameLabel.text = self.instaPost.username
        self.authorUserNameLabel.text = "@" + self.instaPost.username
        self.tweetContentsLabel.text = self.instaPost.caption
        self.mediaImageHeightConstraint.isActive = false
        self.mediaImageView.layer.cornerRadius = 5
        self.mediaImageView.clipsToBounds = true;
        self.mediaImageView.setImageWith(URL(string: self.instaPost.takenPhoto)!)
        self.displayPhoto()
        self.instagramLogoOutlet.imageView?.image = UIImage(named: "InstagramLogo Filled")
        self.twitterLogoOutlet.imageView?.image = UIImage(named: "Twitter")
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
    
    func displayPhoto() {
        self.mediaImageVerticalSpacingConstraint.constant = 8
        self.mediaImageView.isHidden = false
        self.mediaImageView.alpha = 1
    }
    
}

