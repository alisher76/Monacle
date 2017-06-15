//
//  FriendsListTableViewCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/8/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class FriendsListTableViewCell: UITableViewCell {
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    
    var delegate: HomeTableViewController?
    var indexNum: Int?
    var monocleFriends = [MonocleUser]() {
        didSet{
            print(monocleFriends.count)
            
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
    extension FriendsListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return monocleFriends.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            indexNum = indexPath.row
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CustomCollectionCell
            cell.collectionImageTitleLbl.text = monocleFriends[indexPath.row].name
            cell.collectionImageView.setImageWith(URL(string: monocleFriends[indexPath.row].profileImage)!)
            return cell
            
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            // delegate?.userID = monocleFriends[indexPath.row].userID
            delegate?.selectedFriend = monocleFriends[indexPath.row]
        }
        
    }
 
    class CustomCollectionCell: UICollectionViewCell  {
        
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



