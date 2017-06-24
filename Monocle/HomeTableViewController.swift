//
//  HomeTableViewController.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/4/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var selectedPost: MonoclePost?
    var indexNum = 0
    var twitterDelegate: FriendsSelectionTableViewController?
    let userDeafaults = UserDefaults.standard
    var instagramAccessToken: String?
    var monocleFriends: [MonocleUser] = []
    var delegate: InstagramHomeTableViewController?
    var selectedFriend: MonocleUser? {
        didSet {
            getMonocleTimeline()
        }
    }
    
    var monoclePosts: [MonoclePost] = [] {
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
            if userID == nil {
                fetchSavedData()
            }else{
            getTwitterFriendTimeline(userID: userID!)
            }
        }
    }
    var lastTweetID: Int?
    
    var refreshControll: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .default
        let logo = UIImage(named: "icons8-Monocle-100")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        tableView.estimatedRowHeight = 200.0
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tabBarController?.tabBar.isHidden = true
        self.navigationItem.titleView = imageView
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        fetchSavedData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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
        if monoclePosts.count == 0 {
            
            return monoclePosts.count
        }else{
            return monoclePosts.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexNum = indexPath.row
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailView" {
            OperationQueue.main.addOperation {
            let destination = segue.destination as! DetailTableViewController
            destination.monoclePost = self.monoclePosts[self.indexNum]
            destination.monocleUser = self.selectedFriend
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
          let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell") as! FriendsListTableViewCell
              cell.delegate = self
              cell.selectionStyle = .none
              tableView.separatorStyle = .none
              cell.monocleFriends = monocleFriends
              return cell
         }else{
            
          let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.homeCell, for: indexPath) as! TweetCell
              tableView.separatorStyle = .none
              cell.selectionStyle = .none
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
    
    func getMonocleTimeline() {
        if selectedFriend?.accounts?.count == 1 {
            getTwitterFriendTimeline(userID: (selectedFriend?.twitterID)!)
        }else if selectedFriend?.accounts?.count == 2 {
            getMonacleFriendTimelineForBothAccounts(twitterID: (selectedFriend?.twitterID)!, instagramID: (selectedFriend?.instagramID)!)
        }
    }
    
    func getTwitterFriendTimeline(userID: String) {
        
        TwitterClient.sharedInstance?.getUserTimelineMonocle(userID: userID, success: { (monoclePost) in
            self.monoclePosts = monoclePost
            print(monoclePost)
            print(userID)
        }, failure: { (error) in
            print(error)
        })
    }
    
    func getInstagramFriendTimeline(userID: String) {
        
        Instagram().fetchRecentMediaForUserMonocle(userID, accessToken: self.instagramAccessToken!) { (monocleFeed) in
                self.monoclePosts = monocleFeed
        }
    }
    
    func getMonacleFriendTimelineForBothAccounts(twitterID: String, instagramID: String) {
        
        OperationQueue.main.addOperation {
        TwitterClient.sharedInstance?.getUserTimelineMonocle(userID: twitterID, success: { (monoclePost) in
            self.monoclePosts = monoclePost
        }, failure: { (error) in
            print(error)
        })
            
            
        Instagram().fetchRecentMediaForUserMonocle(instagramID, accessToken: self.instagramAccessToken!) { (monocleFeed) in
            for feed in monocleFeed {
                self.monoclePosts.append(feed)
              }
            }
        }
    }
    
    func fetchSavedData() {
        
        if monocleFriends.count == 0 {
            let savedData = self.userDeafaults.object(forKey: "savedFriends") as? [NSDictionary]
            let savedToken = self.userDeafaults.object(forKey: "accessTokenForInstagram") as? String ?? "not logged in"
            let userFriends = TwitterUser.array(json: savedData!)!
            self.friends = userFriends
            self.userID = userFriends.first?.uid
            self.instagramAccessToken = savedToken
            var savedMonacleFriends = [MonocleUser]()
            
            for friends in userFriends {
                let monocleUser = MonocleUser(name: friends.name, userName: friends.screenName, twitterID: friends.uid, instagramID: "nil", profileImage: friends.image, accounts: [MonocolAccount.twitter(friends)], posts: [])
                savedMonacleFriends.append(monocleUser)
             }
            self.monocleFriends = savedMonacleFriends
            }
    }
    
    func showFriendsSelectionVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "friendsSelectionTableViewController") as! FriendsSelectionTableViewController
        vc.listOfCurrentMonocleUser = monocleFriends
        vc.delegate = self
        vc.nextBUttonOutlet.alpha = 0
        self.show(vc, sender: self)
        
    }
    
    
    @IBAction func instagramLogoTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "selectFriendsInstagram") as! InstagramHomeTableViewController
        vc.twitterID = selectedFriend?.twitterID
        vc.monocleFriends = monocleFriends
        vc.delegate = self
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

extension HomeTableViewController : InstagramHomeFriendsTableViewControllerDelegate, FriendsSelectionTableViewControllerDelegate {
    
    func friendsSelectionTableViewController(_ viewController: FriendsSelectionTableViewController, didUpdateFriendsList lists: ([TwitterUser], [MonocleUser])) {
        friends = lists.0
        monocleFriends = lists.1
        
        // added by TJ.
        selectedFriend = monocleFriends.first
        tableView.reloadData()
    }
    
    func instagramHomeFriendsTableViewController(_ viewController: InstagramHomeTableViewController, didUpdateFriendsList lists: ([MonocleUser], String)) {
        monocleFriends = lists.0
        instagramAccessToken = lists.1
        selectedFriend = monocleFriends.first
        tableView.reloadData()
    }
}



