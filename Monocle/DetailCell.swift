//
//  DetailCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/16/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {
    
    var delegate: DetailTableViewController?
    @IBOutlet var instagramIconButton: UIButton!
    @IBOutlet var twitterIconLabel: UIButton!
    @IBOutlet var profileImageOutlet: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var captionLabel: UILabel!
    @IBOutlet var mediaImageView: UIImageView!
    
    var tweet: Tweet? {
        
        didSet {
            updateUI()
        }
    }
    var media: Media? {
        didSet {
            updateMediaUI()
            delegate?.tableView.reloadData()
        }
    }
    
    var monocleUser: MonocleUser? {
        didSet{
            updateUI()
        }
    }
    var monoclePost: MonoclePost! {
        didSet {
            switch monoclePost {
            case .some(.tweet(let value)):
                tweet = value
                print(value)
            case .some(.instagram(let value)):
                media = value
                print(value)
            case .none:
                print("something went wrong")
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
    
    func updateUI() {
        
        if monoclePost != nil {
            profileImageOutlet.setImageWith((tweet?.authorProfilePic)!)
            nameLabel.text = tweet?.author
            captionLabel.text = tweet?.text
            let media = tweet?.media
            instagramIconButton.imageView?.image = UIImage(named: "InstagramLogo")
            twitterIconLabel.imageView?.image = UIImage(named: "Twitter Filled")
            if let media = media {
                for medium in media {
                    
                    let urltext = medium["url"] as! String
                    self.captionLabel.text = self.captionLabel.text?.replcae(target: urltext, withString: " ")
                    if((medium["type"] as? String) == "photo") {
                        
                        let mediaurl = medium["media_url_https"] as! String
                        
                       
                        self.mediaImageView.layer.cornerRadius = 5
                        self.mediaImageView.clipsToBounds = true
                         OperationQueue.main.addOperation {
                        self.mediaImageView.setImageWith(URLRequest(url: URL(string: mediaurl)!), placeholderImage: nil, success: { (request, response, image) -> Void in
                            // success
                            self.mediaImageView.image = image
                            self.delegate?.tableView.reloadData()
                        }, failure: { (request, response, error) -> Void in
                            // error
                        });
                    }
                        
                    }
                }
            }
        }
        
        }
    
    func updateMediaUI(){
        if monoclePost != nil {
            OperationQueue.main.addOperation {
            self.instagramIconButton.imageView?.image = UIImage(named: "InstagramLogo Filled")
            self.twitterIconLabel.imageView?.image = UIImage(named: "Twitter")
            self.profileImageOutlet.setImageWith(URL(string: (self.media?.avatarURL)!)!)
            self.nameLabel.text = self.media?.username
            self.captionLabel.text = self.media?.caption
            self.mediaImageView.setImageWith(URL(string: (self.media?.takenPhoto)!)!)
                self.delegate?.tableView.reloadData()
            }
            
        }
  }
}
