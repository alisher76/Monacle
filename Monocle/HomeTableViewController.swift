//
//  HomeTableViewController.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/4/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweets: [Tweet]?
    var refreshControll: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.shared.statusBarStyle = .default
        let logo = UIImage(named: "Icon-Twitter")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        self.navigationItem.titleView = imageView   
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
        reloadData()
    
        //Set up refreshControll
        
        refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(HomeTableViewController.reloadData), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControll, at: 0) 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets == nil {
            return 0
        }else {
            return (tweets?.count)!
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell") as! TweetCell
        
        cell.tweet = tweets![indexPath.row]
        

        return cell
    }


    func reloadData()  {
        TwitterClient.sharedInstance?.getHomeTimeline(success: { (tweets) in
            self.tweets = tweets
            self.tableView.reloadData()
            self.refreshControll.endRefreshing()
        }, failure: { (error) in
            print(error)
        })
    }

}
