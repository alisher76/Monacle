//
//  DetailPhotoViewController.swift
//  InstaFeed
//
//  Created by Константин on 04.11.15.
//  Copyright © 2015 Константин. All rights reserved.
//

import UIKit

class DetailPhotoViewController: UIViewController {
    
    var photo: NSDictionary?
    var imageView: UIImageView?
    var animator: UIDynamicAnimator?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        
        imageView = UIImageView(frame: CGRectMake(0, -320, self.view.bounds.size.width, self.view.bounds.size.width))
        self.view.addSubview(imageView!)
        
        if let photoDictionary = photo {
            InstagramData.imageForPhoto(photoDictionary, size: "standard_resolution", completion: { (image) -> Void in
                self.imageView!.image = image
            })
        }
        
        let tap = UITapGestureRecognizer(target: self, action: "close")
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        let snap = UISnapBehavior(item: self.imageView!, snapToPoint: self.view.center)
        self.animator?.addBehavior(snap)
    }
    
    func close() {
        self.animator?.removeAllBehaviors()
        
        let snap = UISnapBehavior(item: self.imageView!, snapToPoint: CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds) + 180))
        self.animator?.addBehavior(snap)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
