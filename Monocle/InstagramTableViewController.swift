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
    var splashDelegate: SplashViewController?
    var monocleUser: [MonocleUser]! {
        didSet {
            print(monocleUser.count)
        }
    }
   
    var friends: [InstagramUser]! {
        didSet {
        fetchUserPosts(userID: (friends.first?.uid)!)
        fetchInstaMonoclePost(userID: (friends.first?.uid)!)
            
        }
    }
    
    var monoclePosts: [MonoclePost] = []{
        didSet {
            print(monoclePosts.count)
        }
    }
    var tweets: [Media] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var selectedUser: InstagramUser?
    var indexNum: Int!
    var photoDictionaries = [[String:Any]]()

    
    struct StoryboardCellIdentifier {
        static let friendsCell = "FriendsListCell"
        static let headerCell = "HeaderCell"
        static let postCell = "PostCell"
        static let commentCell = "CommentCell"
        static let postHeaderHeight = 100.0
        static let postCellDefaultHeight = 537.0
    }
    
    
    var posts: [Media] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var refreshControll: UIRefreshControl!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = CGFloat(StoryboardCellIdentifier.postCellDefaultHeight)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        let savedUsers = userDeafaults.object(forKey: "savedInstagramFriends") as? [NSDictionary]
        
        if accessToken == nil  && savedUsers == nil {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let vc = storyboard.instantiateViewController(withIdentifier: "selectFriendsInstagram") as UIViewController
           self.navigationController?.pushViewController(vc, animated: true)
        }else{
            fetchSavedData()
        }
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
            return posts.count + 1
        }
    }
    
    func sUser(user: InstagramUser){
        selectedUser = user
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardCellIdentifier.friendsCell) as! IntagramFriendsTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            cell.friends = friends
            return cell
            
       }else{

            let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardCellIdentifier.postCell , for: indexPath) as! PostsTableViewCell
            cell.selectionStyle = .none
            cell.media = posts[indexPath.row - 1]
        if selectedUser != nil {
            cell.user = selectedUser
        }
            return cell
            }
    }
    
    
    func fetchSavedData() {
        
        if let savedData = self.userDeafaults.object(forKey: "savedInstagramFriends") as? [NSDictionary] {
        let savedToken = self.userDeafaults.object(forKey: "accessTokenForInstagram") as! String
 
        self.accessToken = savedToken
        var savedFriends: [InstagramUser] = []
        for friend in savedData {
            let savedFriend = InstagramUser(fullName: friend["name"] as! String, userName: friend["userName"] as! String, uid: friend["uid"] as! String, image: friend["image"] as! String, accountType: friend["accountType"] as! String)
            
            savedFriends.append(savedFriend)
        }
        friends = savedFriends
        }else{
        splashDelegate?.goToInstaApp()
        }
        
    }
    // FetchMonacleFeed
    func fetchInstaMonoclePost(userID: String) {
        Instagram().fetchRecentMediaForUserMonocle(userID, accessToken: accessToken!) { (monocleFeed) in
            for feed in monocleFeed {
                print(feed)
                self.monoclePosts.append(feed)
            }
        }
    }
    
    func fetchUserPosts(userID: String) {
        Instagram().fetchRecentMediaForUser(userID, accessToken: accessToken!) { (posts) in
            self.posts = posts
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
