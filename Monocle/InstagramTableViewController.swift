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
    var accessToken: String?
    
    var friends: [InstagramUser]! {
        didSet {
        fetchUserPosts(userID: (friends.first?.uid)!)
        }
    }
    
    
    var tweets: [Instagram.Media] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var indexNum: Int! {
        didSet {
        
        }
    }
    var photoDictionaries = [[String:Any]]()

    
    struct StoryboardCellIdentifier {
        static let friendsCell = "FriendsListCell"
        static let headerCell = "HeaderCell"
        static let postCell = "PostCell"
        static let commentCell = "CommentCell"
    }
    
    
    var posts: [Instagram.Media] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var refreshControll: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 450
        tableView.rowHeight = UITableViewAutomaticDimension
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
            return posts.count
        }else{
            return posts.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardCellIdentifier.friendsCell) as! IntagramFriendsTableViewCell
            cell.delegate = self
            cell.friends = friends
            return cell
            
       }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardCellIdentifier.postCell , for: indexPath) as! PostsTableViewCell
            cell.media = posts[indexPath.row]
            return cell
            }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardCellIdentifier.headerCell) as! HeaderTableViewCell
        var frame = cell.frame
        frame.size.height = 100
        cell.frame = frame
        cell.header = posts[section]
        print(posts[section])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0,y: 0, width: tableView.frame.size.width, height: 40))
        footerView.backgroundColor = UIColor.white
        
        return footerView
    }
    
    func fetchSavedData() {
        
        let savedData = self.userDeafaults.object(forKey: "savedInstagramFriends") as! [NSDictionary]
        let savedToken = self.userDeafaults.object(forKey: "accessTokenForInstagram") as! String
        self.accessToken = savedToken
        var savedFriends: [InstagramUser] = []
        for friend in savedData {
            let savedFriend = InstagramUser(fullName: friend["name"] as! String, userName: friend["userName"] as! String, uid: friend["uid"] as! String, image: friend["image"] as! String)
            
            savedFriends.append(savedFriend)
        }
        friends = savedFriends
    }
    
    func fetchUserPosts(userID: String) {
        Instagram().fetchRecentMediaForUser(userID, accessToken: accessToken!) { (posts) in
            self.posts = posts
            print(posts.count)
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if posts.count != 0 {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
                // reloadData(appending: true)
            }
        }
    }

}
