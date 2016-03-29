//
//  LunchDetailViewController.swift
//  mensaapp
//
//  Created by Hans Knöchel on 28.03.16.
//  Copyright © 2016 Hans Knoechel. All rights reserved.
//

import UIKit

class LunchDetailViewController: UIViewController, UISplitViewControllerDelegate {
    
    // MARK: Properties
    var images: NSArray!
    var lunch: Lunch! {
        didSet {
            self.setUI()
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet var placeholder: UIView!
    
    // MARK: Methods
    
    /**
     Refreshes the detail view.
     */
    func setUI() {
        images = self.lunch.images
        if images != nil && images.count > 0 {
            let url: NSURL = NSURL(string: images[0] as! String)!
            let data: NSData = NSData(contentsOfURL: url)!
            
            dispatch_async(dispatch_get_main_queue(), {
                self.image.image = UIImage(data: data)
                self.showImage()
            })
        } else {
            (self.placeholder.subviews[1] as? UILabel)!.text = "Kein Foto vorhanden"
            self.hideImage()
        }
        
        self.navigationBar.topItem?.title = self.lunch.name
    }
    
    /**
     Hides the detail image.
     */
    func hideImage() {
        dispatch_async(dispatch_get_main_queue(), {
            self.image.hidden = true
        })
    }
    
    /**
     Shows the detail image.
     */
    func showImage() {
        dispatch_async(dispatch_get_main_queue(), {
            self.image.hidden = false
        })
    }
    
    func configureImage() {
        image.layer.shadowOffset = CGSizeMake(10, 15)
        image.layer.shadowColor = UIColor.grayColor().CGColor
        image.layer.shadowRadius = 15
        image.layer.shadowOpacity = 0.7
    }
    
    // MARK: Delegates
    
    override func viewDidLoad() {
        splitViewController?.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        self.configureImage()
    }
}
