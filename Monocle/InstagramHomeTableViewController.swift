//
//  InstagramHomeTableViewController.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/4/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class InstagramHomeTableViewController: UITableViewController {
    
    let userDefaults = UserDefaults.standard
    
    var monocleFriends: [MonocleUser]?
    var twitterID: String!
    var accessToken: String! {
        didSet {
        fetchUsersFollowed()
        }
    }
    
    var listOfUser:[InstagramUser] = [] {
        didSet {
            
        }
    }
    
    var selectedUsersRegular: [String : InstagramUser] = [:]
    
    var indexNum = 0

   
    var photoDictionaries = [[String:Any]]()
    
    struct StroryBoard {
        static let exploreCell = "friendsList"
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let savedUsers = userDefaults.object(forKey: "savedInstagramFriends") as? [NSDictionary]
        
        if accessToken == nil {
            authInstagram()
        }else if accessToken != nil {
            fetchUsersFollowed()
        }
        
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
        let cell = tableView.cellForRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        let user = listOfUser[indexPath.row]
        if cell?.accessoryType == .checkmark{
            self.selectedUsersRegular.removeValue(forKey: user.userName)
            print("\(user.userName)")
            print(selectedUsersRegular)
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
            self.selectedUsersRegular[user.userName] = user
            print(selectedUsersRegular)
            print(self.selectedUsersRegular.count)
        }

    }

    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "twitterHomePage")  as! HomeTableViewController
        
        
            var sUsers: [InstagramUser] = []
            var selectedFriends: [NSDictionary] = []
            for (_ , value) in self.selectedUsersRegular {
                sUsers.append(value)
                
                let dictioanry: NSDictionary = [
                    "name" : value.fullName,
                    "userName" : value.userName,
                    "uid"  : value.uid,
                    "image": value.image,
                    "accountType" : value.accountType
                ]
                selectedFriends.append(dictioanry)
            }
        
        for friend in monocleFriends! {
                if friend.twitterID == self.twitterID {
                friend.accounts?.append(MonocolAccount.instagram(self.selectedUsersRegular[listOfUser[indexNum].userName]!))
                    friend.instagramID = listOfUser[indexNum].uid
                    vc.instagramAccessToken = accessToken
                    vc.selectedFriend = friend
                }
            }
            vc.monocleFriends = self.monocleFriends!
            self.userDefaults.set(selectedFriends, forKey: "savedInstagramFriends")
            self.userDefaults.synchronize()
        
        self.navigationController?.pushViewController(vc, animated: true)
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
            OperationQueue.main.addOperation {
                self.tableView?.reloadData()
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

