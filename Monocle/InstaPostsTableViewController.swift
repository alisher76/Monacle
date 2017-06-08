//
//  InstaPostsTableViewController.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/6/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class InstaPostsTableViewController: UITableViewController {
    
    var medias: [Instagram.Media] = [] {
        didSet {
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    var accessToken: String!{
        didSet {
            fetchUserPosts()
        }
    }
    var uID: String!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if medias.count == 0 {
            return 0
        }else{
            return medias.count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! InstagramPostsTableViewCell
        cell.media = medias[indexPath.row]
        return cell
    }
    
    func fetchUserPosts() {
       Instagram().fetchRecentMediaForUser(uID, accessToken: accessToken) { (media) in
        self.medias = media
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
      }
    
    }

}
