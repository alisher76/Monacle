//
//  HomeTableViewController.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/4/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    let userDeafaults = UserDefaults.standard
    var instagramAccessToken: String?
    var monocleFriends: [MonocleUser] = []
    
    var selectedFriend: MonocleUser? {
        didSet {
            if selectedFriend?.accounts?.count == 1 {
                getMonacleFriendTimeline(userID: (selectedFriend?.twitterID)!)
            }else{
                getMonacleFriendTimelineForBothAccounts(twitterID: (selectedFriend?.twitterID)!, instagramID: (selectedFriend?.instagramID)!)
            }
        }
    }
    
    var monoclePosts: [MonoclePost] = []{
        didSet {
            tableView.reloadData()
        }
    }
    var friends = [TwitterUser]()
    
    var instagramUserID: String?
    
    struct Storyboard {
        static let friendsCell = "friendsListCell"
        static let homeCell = "HomeCell"
    }
    
    
    var userID: String? {
        didSet {
            getMonacleFriendTimeline(userID: userID!)
        }
    }
    var lastTweetID: Int?
    
    
    var refreshControll: UIRefreshControl!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        let logo = UIImage(named: "Icon-Twitter")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.titleView = imageView
        
        fetchSavedData()
    }

        //Set up refreshControll
        
//        refreshControll = UIRefreshControl()
//        refreshControll.addTarget(self, action: #selector(HomeTableViewController.reloadData), for: UIControlEvents.valueChanged)
//        tableView.insertSubview(refreshControll, at: 0)
    

    
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
        if monoclePosts.count == 0 {
            fetchSavedData()
            return monoclePosts.count
        }else{
            return monoclePosts.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
          let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell") as! FriendsListTableViewCell
              cell.delegate = self
              cell.monocleFriends = monocleFriends
              return cell
         }else{
          let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.homeCell, for: indexPath) as! TweetCell
              tableView.separatorStyle = UITableViewCellSeparatorStyle.none
              cell.selectionStyle = UITableViewCellSelectionStyle.none
              cell.monoclePost = monoclePosts[indexPath.row]
              return cell
        }
    }
    
    func updateNavigationImagge(image: String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.setImageWith(URL(string: image)!)
        self.navigationItem.titleView = imageView
    }
    
    
    func getMonacleFriendTimeline(userID: String) {
        
        TwitterClient.sharedInstance?.getUserTimelineMonocle(userID: userID, success: { (monoclePost) in
            self.monoclePosts = monoclePost
        }, failure: { (error) in
            print(error)
        })
    }
    
    func getMonacleFriendTimelineForBothAccounts(twitterID: String, instagramID: String) {
        
        TwitterClient.sharedInstance?.getUserTimelineMonocle(userID: twitterID, success: { (monoclePost) in
            self.monoclePosts = monoclePost
        }, failure: { (error) in
            print(error)
        })
        
        Instagram().fetchRecentMediaForUserMonocle(instagramID, accessToken: instagramAccessToken!) { (monocleFeed) in
            for feed in monocleFeed {
                print(feed)
                self.monoclePosts.append(feed)
            }
            print(self.monoclePosts.count)
        }
    }
    
   
    
    func fetchSavedData() {
        
        if monocleFriends.count == 0{
        let savedData = self.userDeafaults.object(forKey: "savedFriends") as! [NSDictionary]
        guard let userFriends = TwitterUser.array(json: savedData) else {return}
        self.friends = userFriends
        self.userID = userFriends.first?.uid
        var savedMonacleFriends = [MonocleUser]()
        
        for friends in userFriends {
            let monocleUser = MonocleUser(name: friends.name, userName: friends.screenName, twitterID: friends.uid, instagramID: "nil", profileImage: friends.image, accounts: [MonocolAccount.twitter(friends)], posts: [])
            savedMonacleFriends.append(monocleUser)
        }
            self.monocleFriends = savedMonacleFriends
            
        }
    }
    
    
    
    @IBAction func instagramLogoTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "selectFriendsInstagram") as! InstagramHomeTableViewController
        vc.twitterID = selectedFriend?.twitterID
        vc.monocleFriends = monocleFriends
        self.navigationController?.pushViewController(vc, animated: true)
        print("tapped")
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        if tweets.count != 0 {
        //            let scrollViewContentHeight = tableView.contentSize.height
        //            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        //
        //            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
        //               // reloadData(appending: true)
        //            }
        //        }
    }
    
    @IBAction func twitterButtonTapped(_ sender: Any) {
        
    }
    /*
     func reloadData(appending: Bool = false)  {
     
     TwitterClient.sharedInstance?.getHomeTimeline(maxID: lastTweetID, success: { (tweets) in
     self.tweets = tweets
     self.tableView.reloadData()
     if (appending) {
     var cleaned = tweets
     if tweets.count > 0 {
     cleaned.remove(at: 0)
     }
     
     if cleaned.count > 0 {
     self.tweets.append(contentsOf: cleaned)
     self.tableView.reloadData()
     }
     }else{
     self.lastTweetID = nil
     }
     
     }, failure: { (error) in
     print(error)
     })
     
     }
     */
}



