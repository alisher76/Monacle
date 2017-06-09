//
//  InstagramTableViewController.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/9/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class InstagramTableViewController: UITableViewController {

    let userDeafaults = UserDefaults.standard
    
    
    var accessToken: String!{
        didSet {
          // fetchUsersFollowed()
        }
    }
    
    var listOfUser:[Instagram.User] = [] {
        didSet {
            print(listOfUser.count)
        }
    }

    var indexNum: Int! {
        didSet {
         //   cellTapped()
        }
    }

    
    var photoDictionaries = [[String:Any]]()
    struct StroryBoard {
        static let exploreCell = "exploreCell"
    }

    
    var friends:[Instagram.User] = []
    
    struct Storyboard {
        static let friendsCell = "friendsListCell"
        static let homeCell = "media"
        static let comment = "comment"
    }
    
    var userID: String? {
        didSet {
            getUserTimeline(userID: userID!)
        }
    }
    var lastTweetID: Int?
    var posts: [Instagram.Media] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var refreshControll: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        fetchSavedData()
    }
    
   
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100.0
        } else {
            return UITableViewAutomaticDimension
            
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts.count == 0 {
            fetchSavedData()
            return posts.count
        }else{
            return posts.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell") as! IntagramFriendsTableViewCell
                cell.delegate = self
                cell.friends = friends
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.homeCell, for: indexPath) as! TweetCell
            
            return cell
        }
    }
    
    
    
    func reloadData(appending: Bool = false)  {
        
        
    }
    
    func getUserTimeline(userID: String) {
        
        
    }
    
    func fetchSavedData() {
        
        let savedData = self.userDeafaults.object(forKey: "savedFriends") as! [NSDictionary]
        //guard let userFriends = TwitterUser.array(json: savedData) else {return}
//        self.friends = userFriends
//        self.userID = userFriends.first?.uid
    }
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if posts != nil {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
                // reloadData(appending: true)
            }
        }
    }

}
