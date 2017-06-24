//
//  FriendsListTableViewCell.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/8/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class FriendsListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    
    @IBOutlet var collectionView: UICollectionView!
    
    var delegate: HomeTableViewController?
    var instagramDelegate: FriendsSelectionTableViewController?
    var indexNum: Int?
    
    var selectedFriend: MonocleUser?
    
    var monocleFriends = [MonocleUser]() {
        didSet{
            collectionView.reloadData()
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
    
    
    @IBAction func segmentedChangedValue(_ sender: Any) {
        
        if selectedFriend == nil {
            selectedFriend = monocleFriends.first
        }
        switch (segmentedControll.selectedSegmentIndex){
        case 0:
            delegate?.getMonocleTimeline()
        case 1:
            guard let twitterID = selectedFriend?.twitterID else{return}
            delegate?.getTwitterFriendTimeline(userID: twitterID)
        case 2:
            guard let instagramID = selectedFriend?.instagramID else{return}
            delegate?.getInstagramFriendTimeline(userID: instagramID)
        default:
            delegate?.selectedFriend = selectedFriend
        }
        delegate?.tableView.reloadData()
    }
}
    extension FriendsListTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return monocleFriends.count + 1
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if indexPath.row == 0 {
             let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddButtonCollectionCell", for: indexPath)
            return cell
            } else {
            indexNum = indexPath.row
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! CustomCollectionCell
            cell.collectionImageTitleLbl.text = monocleFriends[indexPath.row - 1].name
            cell.collectionImageView.setImageWith(URL(string: monocleFriends[indexPath.row - 1].profileImage)!)
            return cell
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
              //  instagramDelegate.userID = monocleFriends[indexPath.row].userID
            if indexPath.row != 0 {
                segmentedControll.selectedSegmentIndex = 0
                selectedFriend = monocleFriends[indexPath.row - 1]
                delegate?.selectedFriend = monocleFriends[indexPath.row - 1]
            }else{
                delegate?.showFriendsSelectionVC()
            }
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



