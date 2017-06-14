//
//  LikesTableViewController.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/11/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class LikesTableViewController: UITableViewController {
    
    
    let userDeafaults = UserDefaults.standard
    var friends = [TwitterUser]()
    
    var media = [MonoclePost]() {
        didSet {
            print(media)
        }
    }
    
    var delegate: SplashViewController?
    
    struct Storyboard {
        static let friendsCell = "friendsListCell"
        static let homeCell = "HomeCell"
    }
    
    var userID: String? {
        didSet {
            getUserTimeline(userID: userID!)
            getMonocleData(userID: userID!)
        }
    }
    var lastTweetID: Int?
    
    var tweets: [Tweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        if tweets.count == 0 {
            fetchSavedData()
            return tweets.count
        }else{
            return tweets.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "friendsCell") as! FraindsListViewCell
            cell.delegate = self
            cell.friends = friends
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.homeCell, for: indexPath) as! LikedTweetCell
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.tweet = tweets[indexPath.row]
            cell.friends = friends
            return cell
        }
    }
    
    
    
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
    
    func getMonocleData(userID: String) {
        TwitterClient.sharedInstance?.getUserTimelineMonocle(userID: userID, success: { (monocleTweet) in
            self.media = monocleTweet
        }, failure: { (error) in
            print(error)
        })
    }
    
    func getUserTimeline(userID: String) {
        
        TwitterClient.sharedInstance?.getUserLikes(userID: userID, success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error) in
            print("error")
        })
    }
    
    func fetchSavedData() {
        
        let savedData = self.userDeafaults.object(forKey: "savedFriends") as! [NSDictionary]
        guard let userFriends = TwitterUser.array(json: savedData) else {return}
        self.friends = userFriends
        self.userID = userFriends.first?.uid
    }
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if tweets.count != 0 {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
            if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
                // reloadData(appending: true)
            }
        }
    }
    
    @IBAction func instagramLogoTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "splash") as UIViewController
        self.show(vc, sender: self)
        print("tapped")
    }
}
