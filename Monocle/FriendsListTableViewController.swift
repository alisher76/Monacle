//
//  FriendsListTableViewController.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/5/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class FriendsListTableViewController: UITableViewController {

    var users: [TwitterUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getFriendsList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if users != nil {
            return (users?.count)!
        }else{
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendsTVCell
        

        cell.user = users?[indexPath.row]

        return cell
    }
    
    
    func getFriendsList()  {
        
        TwitterClient.sharedInstance?.getListOfFollowedFriends(success: { (twitterUser) in
            
            self.users = twitterUser
            self.tableView.reloadData()
            
        }, failure: { (error) in
            print("error")
        })
        
        
    }

}
