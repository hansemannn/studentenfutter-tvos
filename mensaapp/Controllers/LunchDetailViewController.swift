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
    var images: Array<String>!
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
            let url: URL = URL(string: images[0])!
            let data: Data = try! Data(contentsOf: url)
            
            DispatchQueue.main.async(execute: {
                self.image.image = UIImage(data: data)
                self.showImage()
            })
        } else {
            (self.placeholder.subviews[2] as? UILabel)!.text = "Kein Foto vorhanden"
            self.hideImage()
        }
        
        self.navigationBar.topItem?.title = self.lunch.name
    }
    
    /**
     Hides the detail image.
     */
    func hideImage() {
        DispatchQueue.main.async(execute: {
            self.image.isHidden = true
        })
    }
    
    /**
     Shows the detail image.
     */
    func showImage() {
        DispatchQueue.main.async(execute: {
            self.image.isHidden = false
        })
    }
    
    func configureImage() {
        image.layer.shadowOffset = CGSize(width: 10, height: 15)
        image.layer.shadowColor = UIColor.gray.cgColor
        image.layer.shadowRadius = 15
        image.layer.shadowOpacity = 0.7
    }
    
    // MARK: Delegates
    
    override func viewDidLoad() {
        splitViewController?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.configureImage()
    }
}
