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
    var listOfUser:[Instagram.User] = [] {
        didSet {
            print(listOfUser.count)
        }
    }
    var indexNum: Int! {
        didSet {
           cellTapped()
        }
    }
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
        indexNum = indexPath.row
    }

    func authInstagram() {
        
        //SaveChanges
        let userDefaults = UserDefaults.standard
        
        if let token = userDefaults.object(forKey: "accessToken") as? String {
            self.accessToken = token
            print("Already logged in\(accessToken)")
           
        } else {
            
            SimpleAuth.authorize("instagram", options: ["scope": ["follower_list public_content"]]) { (oResult: Any?, error: Error?) -> Void in
                
                // Getting data and also accessing to Token
                if let result = oResult as? [String:Any] {
                    let credentials = result["credentials"] as! [String:Any]
                    let accessToken = credentials["token"] as! String
                    self.accessToken = accessToken
                    userDefaults.set(self.accessToken, forKey: "accessToken")
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
    
    
}

