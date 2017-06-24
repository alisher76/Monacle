//
//  FriendsSelectionTableViewController.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/7/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

protocol FriendsSelectionTableViewControllerDelegate: class {
    func friendsSelectionTableViewController(_ viewController: FriendsSelectionTableViewController, didUpdateFriendsList lists: ([TwitterUser], [MonocleUser]))
}

class FriendsSelectionTableViewController: UITableViewController  {
    
    
    @IBOutlet var nextBUttonOutlet: UIButton!
    weak var delegate: FriendsSelectionTableViewControllerDelegate?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let userDefault = UserDefaults.standard
    
    var listOfCurrentMonocleUser: [MonocleUser] = [] {
        didSet{
        fetchSavedData()
        }
    }
    var listOfMonocleUser:[MonocleUser] = []
    
    var selectedFriends: [NSDictionary] = []
    
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
        
        if cell?.accessoryType == .checkmark {
            self.selectedUsers.removeValue(forKey: user.uid)
            cell?.accessoryType = .none
        } else {
            cell?.accessoryType = .checkmark
            self.selectedUsers[user.uid] = user
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FriendsSelectionCell
        
        if selectedUsers[(users?[indexPath.row].uid)!] != nil {
            cell.accessoryType = .checkmark
            
        }else{
            cell.accessoryType = .none
        }
        cell.user = users?[indexPath.row]
        
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        save()
    }
    
    func save() {
        OperationQueue.main.addOperation { [weak self] in
            guard let strongSelf = self else { return }
            var sUsers: [TwitterUser] = []
            
            for (_ , value) in strongSelf.selectedUsers {
                sUsers.append(value)
                
                let dictioanry: NSDictionary = [
                    "name": value.name,
                    "id_str" : value.uid,
                    "screen_name"  : value.screenName,
                    "followers_count": value.followerCount,
                    "friends_count" : value.followingCount,
                    "description" : value.description,
                    "location" : value.location,
                    "profile_image_url_https" : value.image,
                    "accountType" : value.accountType
                ]
                strongSelf.selectedFriends.append(dictioanry)
            }
            
            for user in sUsers {
                let monocleUser = MonocleUser(name: user.name, userName: user.screenName, twitterID: user.uid, instagramID: "nil", profileImage: user.image, accounts: [MonocolAccount.twitter(user)], posts: [])
                strongSelf.listOfMonocleUser.append(monocleUser)
            }
            
           strongSelf.userDefault.set(strongSelf.selectedFriends, forKey: "savedFriends")
           strongSelf.userDefault.synchronize()
            
           strongSelf.delegate?.friendsSelectionTableViewController(strongSelf, didUpdateFriendsList: (sUsers, strongSelf.listOfMonocleUser))
            }
    }
    
    func fetchSavedData() {
        
        let savedData = userDefault.object(forKey: "savedFriends") as! [NSDictionary]
        guard let userFriends = TwitterUser.array(json: savedData) else {return}
        for friend in userFriends {
            self.selectedUsers[friend.uid] = friend
        }
    }
    
    @IBAction func cake(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "twitterHomePage") as! HomeTableViewController
        
        var sUsers: [TwitterUser] = []
        
        for (_ , value) in self.selectedUsers {
            sUsers.append(value)
            
            let dictioanry: NSDictionary = [
                "name": value.name,
                "id_str" : value.uid,
                "screen_name"  : value.screenName,
                "followers_count": value.followerCount,
                "friends_count" : value.followingCount,
                "description" : value.description,
                "location" : value.location,
                "profile_image_url_https" : value.image,
                "accountType" : value.accountType
            ]
            self.selectedFriends.append(dictioanry)
        }
        
        for user in sUsers {
            let monocleUser = MonocleUser(name: user.name, userName: user.screenName, twitterID: user.uid, instagramID: "nil", profileImage: user.image, accounts: [MonocolAccount.twitter(user)], posts: [])
            self.listOfMonocleUser.append(monocleUser)
        }
        
        self.userDefault.set(self.selectedFriends, forKey: "savedFriends")
        self.userDefault.synchronize()
        
        self.navigationController?.pushViewController(vc, animated: true)
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
