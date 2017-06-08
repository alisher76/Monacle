//
//  InstagramData.swift
//  Monocle
//
//  Created by Alisher Abdukarimov on 6/7/17.
//  Copyright © 2017 MrAliGorithm. All rights reserved.
//

import UIKit
import SAMCache

class InstagramData {
    
    static func imageForPhoto(_ photoDictionary: AnyObject, size: String, completion: @escaping (_ image: UIImage) -> Void) {
        
        let photoID = photoDictionary["id"] as! String
        let key = "\(photoID)-\(size)" // id-thumbnail
        
        if let image = SAMCache.shared().image(forKey: key) {
            completion(image)
        } else {
            
            let urlString = photoDictionary.value(forKeyPath: "images.\(size).url") as! String
            let url = URL(string: urlString)!
            
            let session = URLSession.shared
            let request = URLRequest(url: url)
            let task = session.downloadTask(with: request, completionHandler: { (localFile, response, error) -> Void in
                if error == nil {
                    let data = try? Data(contentsOf: localFile!)
                    let image = UIImage(data: data!)
                    
                    SAMCache.shared().setImage(image, forKey: key)
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        completion(image!)
                    })
                }
            })
            task.resume()
        }
    }
}


