//
//  FraindsListViewCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/11/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class FraindsListViewCell: UITableViewCell {

    @IBOutlet var collectionView: UICollectionView!
    
    var delegate: LikesTableViewController?
    var indexNum: Int?
    //    var friendIDs: [Int]?
    var friends = [TwitterUser]() {
        didSet {
            var friendsDict: [String] = []
            for friend in friends {
                friendsDict.append(friend.uid)
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
    
    
}
extension FraindsListViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        indexNum = indexPath.row
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionLikesCell", for: indexPath) as! CustomCollectionLikesCell
        cell.collectionImageTitleLbl.text = friends[indexPath.row].name
        cell.collectionImageView.setImageWith(URL(string: friends[indexPath.row].image)!)
        
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.getUserTimeline(userID: friends[indexPath.row].uid)
        
    }
    
}

class CustomCollectionLikesCell: UICollectionViewCell  {
    
    
    
    @IBOutlet var collectionImageView: UIImageView!
    @IBOutlet var collectionImageTitleLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpLayer()
    }
    
    
    func setUpLayer() {
        
        collectionImageView.layer.cornerRadius = 5
        collectionImageView.clipsToBounds = true
        collectionImageView.layer.shadowOpacity = 0.7
        collectionImageView.layer.shadowRadius = 10.0
    }
}


