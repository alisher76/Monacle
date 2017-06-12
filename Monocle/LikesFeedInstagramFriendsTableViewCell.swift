//
//  LikesFeedInstagramFriendsTableViewCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/11/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class LikesFeedInstagramFriendsTableViewCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!
    
    var delegate: LikesInstagramTableViewController?
    
    var indexNum: Int?
    var friendIDs: [String]?
    
    var friends: [InstagramUser] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}

extension LikesFeedInstagramFriendsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        indexNum = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InstagramLikesCollectionCell", for: indexPath) as! LikesCustomCollectionCellInstagram
        cell.collectionImageTitleLbl.text = friends[indexPath.row].fullName
        cell.collectionImageView.setImageWith(URL(string: friends[indexPath.row].image)!)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.fetchUserLikes(userID: friends[indexPath.row].uid)
    }
    
}

class LikesCustomCollectionCellInstagram: UICollectionViewCell  {
    
    
    
    @IBOutlet var collectionImageView: UIImageView!
    @IBOutlet var collectionImageTitleLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLayer()
    }
    
    
    func setUpLayer() {
        
        collectionImageView.layer.cornerRadius = collectionImageView.bounds.width / 2.0
        collectionImageView.clipsToBounds = true
        collectionImageView.layer.shadowOpacity = 0.8
        collectionImageView.layer.shadowRadius = 12.0
    }
}
