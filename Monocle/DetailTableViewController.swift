//
//  DetailTableViewController.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/16/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    var monocleUser: MonocleUser? {
        didSet {
            tableView.reloadData()
        }
    }
    var monoclePost: MonoclePost? {
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell", for: indexPath) as! DetailCell
        cell.monocleUser = monocleUser
        cell.monoclePost = monoclePost
        return cell
    }

}
