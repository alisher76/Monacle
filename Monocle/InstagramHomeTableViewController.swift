//
//  InstagramHomeTableViewController.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/4/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class InstagramHomeTableViewController:UITableViewController {
    
    private var accessToken: String!
    var listOfUser = [InstagramUser]()
    var photoDictionaries = [[String:Any]]()
    struct StroryBoard {
        static let exploreCell = "exploreCell"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: StroryBoard.exploreCell, for: indexPath) as! InstagramHomeCell
         cell.userCollection = listOfUser[indexPath.row]
        
        return cell
    }
    

    func authInstagram() {
        
        
        //SaveChanges
        let userDefaults = UserDefaults.standard
        
        if let token = userDefaults.object(forKey: "accessToken") as? String {
            self.accessToken = token
            print("Already logged in\(accessToken)")
           // fetchPhotos()
           // fetchUser()
            self.fetchUsersFollowed()
        } else {
            
            SimpleAuth.authorize("instagram", options: ["scope": ["follower_list public_content"]]) { (oResult: Any?, error: Error?) -> Void in
                // Getting data and also accessing to Token
                if let result = oResult as? [String:Any] {
                    let credentials = result["credentials"] as! [String:Any]
                    let accessToken = credentials["token"] as! String
                    self.accessToken = accessToken
                    print(accessToken)
                    //If a user has not logged in yet then when they do we save a copy
                   // self.fetchUser()
                    //self.fetchPhotos()
                    self.fetchUsersFollowed()
                    userDefaults.set(self.accessToken, forKey: "accessToken")
                    userDefaults.synchronize()
                }
            }
        }
    }
    
    func fetchUser() {
        
        let session = URLSession.shared
        let url: URL = URL(string: "https://api.instagram.com/v1/users/self/?access_token=\(accessToken!)")!
        print(url)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (oData, oResponce, oError) in
            if oError != nil {
                print("error")
                return
            }else{
                if let data = oData {
                    do {
                        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else { return }
                        //print(dictionary)
                        let userData = dictionary["data"] as! [String:Any]
                        let counts = userData["counts"] as! [String:Any]
                        
                        let user = InstagramUser(token: userData["full_name"] as! String, uid: userData["id"] as! String, bio: userData["bio"] as! String, followed_by: counts["followed_by"] as! Int, follows: counts["follows"] as! Int, media: counts["media"] as! Int, username: userData["username"] as! String, image: userData["profile_picture"] as! String)
                        print(user.username)
                        print(user.bio)
                        
                    }catch{
                        print(error)
                    }
                }
            }
            OperationQueue.main.addOperation {
                self.tableView?.reloadData()
            }
        }
        task.resume()
    }
    
    
    func fetchUsersFollowed() {
        
        let session = URLSession.shared
        let url: URL = URL(string: "https://api.instagram.com/v1/users/self/follows?access_token=\(accessToken!)")!
        print(url)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (oData, oResponce, oError) in
            if oError != nil {
                print("error")
                return
            }else{
                if let data = oData {
                    do {
                        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else { return }
                        
                        var collection = [InstagramUser]()
                        let userData = dictionary["data"] as! [[String:Any]]
                        for user in userData{
                        let user = InstagramUser(token: user["full_name"] as! String, uid: user["id"] as! String, bio: user["bio"] as? String ?? " ", followed_by: 30, follows: 10, media: 20, username: user["username"] as! String, image: user["profile_picture"] as! String)
                            print(user.username)
                            collection.append(user)
                        }
                        self.listOfUser = collection
                    }catch{
                        print(error)
                    }
                }
            }
            OperationQueue.main.addOperation {
                self.tableView?.reloadData()
            }
        }
        task.resume()
    }
    



}
