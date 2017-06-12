//
//  InstagramHomeTableViewController.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/4/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class InstagramHomeTableViewController: UITableViewController {
    
    var accessToken: String!{
        didSet {
            fetchUsersFollowed()
        }
    }
    var listOfUser:[InstagramUser] = [] {
        didSet {
            print("select Friends table view controller: count \(listOfUser.count)")
            
        }
    }
    
    var selectedUsers: [String:InstagramUser] = [:]
    var indexNum = 0

   
    var photoDictionaries = [[String:Any]]()
    struct StroryBoard {
        static let exploreCell = "friendsList"
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

        authInstagram()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1 
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listOfUser.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendsList", for: indexPath) as! InstagramHomeCell
         cell.user = listOfUser[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        let user = listOfUser[indexPath.row]
        if cell?.accessoryType == .checkmark{
            self.selectedUsers.removeValue(forKey: user.fullName)
            print(self.selectedUsers.count)
            cell?.tintColor = UIColor.gray
            cell?.accessoryType = .none
            
        } else {
            cell?.tintColor = UIColor.blue
            cell?.accessoryType = .checkmark
            self.selectedUsers[user.fullName] = user
            print(self.selectedUsers.count)
        }

    }

    func authInstagram() {
        
        //SaveChanges
        let userDefaults = UserDefaults.standard
        
        if let token = userDefaults.object(forKey: "accessTokenForInstagram") as? String {
            self.accessToken = token
            print("Already logged in\(accessToken)")
           
        } else {
            
            SimpleAuth.authorize("instagram", options: ["scope": ["follower_list public_content"]]) { (oResult: Any?, error: Error?) -> Void in
                
                // Getting data and also accessing to Token
                if let result = oResult as? [String:Any] {
                    let credentials = result["credentials"] as! [String:Any]
                    let accessToken = credentials["token"] as! String
                    self.accessToken = accessToken
                    userDefaults.set(self.accessToken, forKey: "accessTokenForInstagram")
                    userDefaults.synchronize()
                }
            }
        }
    }
    
    
    func fetchUsersFollowed() {
        
       Instagram().fetchUserFriends(accessToken) { (oUsers) in
        self.listOfUser = oUsers
        print(oUsers)
        OperationQueue.main.addOperation {
            self.tableView?.reloadData()
        }
       }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let userDefaults = UserDefaults.standard
        
        if segue.identifier == "showPosts" {
            let vc = segue.destination as! InstagramTableViewController
            OperationQueue.main.addOperation {
                var sUsers: [InstagramUser] = []
                var selectedFriends: [NSDictionary] = []
                
                for (_ , value) in self.selectedUsers {
                    sUsers.append(value)
                    
                    let dictioanry: NSDictionary = [
                        "name": value.fullName,
                        "userName" : value.userName,
                        "uid"  : value.uid,
                        "image": value.image
                    ]
                    selectedFriends.append(dictioanry)
                }
                
                userDefaults.set(selectedFriends, forKey: "savedInstagramFriends")
                userDefaults.synchronize()
                vc.friends = sUsers
            }
        }
    }
/*
    func cellTapped() {
              let tappedUser = listOfUser[indexNum] 
              let id = tappedUser.uid
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              let controller = storyboard.instantiateViewController(withIdentifier: "Feed") as! InstaPostsTableViewController
              controller.uID = id
              controller.accessToken = accessToken
              controller.title = tappedUser.name
              self.navigationController?.pushViewController(controller, animated: true)
        
    }
*/
    
}

