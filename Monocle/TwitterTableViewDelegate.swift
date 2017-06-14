//
//  TwitterTableViewDelegate.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/12/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import Foundation


protocol TwitterTableViewDelegate: class,  UITableViewDelegate {
    func reloadTableCellAtIndex(_ cell: UITableViewCell, indexPath: IndexPath)
    
}
