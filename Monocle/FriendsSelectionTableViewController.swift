//
//  FriendsSelectionTableViewController.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/7/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class FriendsSelectionTableViewController: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var isCompleted = false
    var users: [TwitterUser]?
    var selectedUsers: [String:TwitterUser] = [:]
    var indexNum = 0
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexNum = indexPath.row
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        guard let user = users?[indexPath.row] else { return }
        if cell?.accessoryType == .checkmark{
            self.selectedUsers.removeValue(forKey: user.name)
            print(self.selectedUsers.count)
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
            self.selectedUsers[user.name] = user
            print(self.selectedUsers.count)
        }
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FriendsSelectionCell
        
        cell.user = users?[indexPath.row]
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTweets" {
            let vc = segue.destination as! HomeTableViewController
            OperationQueue.main.addOperation {
                var sUsers: [TwitterUser] = []
                for (_ , value) in self.selectedUsers {
                sUsers.append(value)
               }
                vc.friends = sUsers
                vc.userID = sUsers.first?.uid
          }
        }
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
