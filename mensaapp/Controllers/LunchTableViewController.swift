//
//  LunchTableViewController.swift
//  mensaapp
//
//  Created by Hans Knöchel on 27.02.16.
//  Copyright © 2016 Hans Knoechel. All rights reserved.
//

import UIKit

class LunchTableViewController: UITableViewController, UISplitViewControllerDelegate, RequestDelegate {
    
    // MARK: Properties
    var loader: UIActivityIndicatorView!
    var request: Request!
    var lunches: [Lunch] = []
    var currentDate: NSDate! = NSDate() {
        didSet {
            self.fetchData()
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var placeholder: UIView!

    // MARK: Methods
    
    /**
     Fetches the current lunch data.
     */
    func fetchData() {
        self.request.load("https://api.studentenfutter-os.de/lunches/list/\(self.formattedDate("YYYY-MM-dd"))/0")
    }
    
    /**
     Shows the loader.
     */
    func showLoader() {
        if loader == nil {
            loader = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            loader.color = UIColor.grayColor()
            loader.center = CGPointMake(self.view.center.x, self.view.center.y - 80)
        }
        
        loader.startAnimating()

        self.lunches = []
        self.tableView.reloadData()
        self.view.addSubview(loader)
    }
    
    /**
     Hides the loader.
     */
    func hideLoader() {
        loader.stopAnimating()
        self.loader.removeFromSuperview()
    }
    
    /**
     Gets the formatted date.
     
     - parameter format: The specified format
     
     - returns: The formatted date
     */
    func formattedDate(format : String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.stringFromDate(self.currentDate)
    }
    
    /**
     Refreshes the master view.
     */
    func setUI() {
        if self.isToday() {
            self.title = "Heute"
        } else {
            self.title = self.formattedDate("dd.MM.yyyy")
        }
        
        self.tableView.reloadData()
        self.validatePlaceholder()
    }
    
    /**
     Validated the current date.
     
     - returns: `true` if the current date is today, `false` otherwise
     */
    func isToday() -> Bool {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.stringFromDate(currentDate) == dateFormatter.stringFromDate(NSDate())
    }
    
    /**
     Validates the placeholder visibility
     */
    func validatePlaceholder() {
        self.placeholder.hidden = self.lunches.count > 0
    }
 
    // MARK: Actions
    
    /**
     Changes the current date to one day later and triggers a new data fetch
     by using it's computed property.
     
     - parameter sender: The right navigationBar button
     */
    @IBAction func showTomorrowLunches(sender: UIBarButtonItem) {
        self.currentDate = self.currentDate.dateByAddingTimeInterval(1*60*60*24) // + 1 day
    }

    /**
     Changes the current date to one day earlier and triggers a new data fetch
     by using it's computed property.
     
     - parameter sender: The left navigationBar button
     */
    @IBAction func showYesterdayLunches(sender: UIBarButtonItem) {
        self.currentDate = self.currentDate.dateByAddingTimeInterval(-1*60*60*24) // - 1 day
    }
    
    // MARK: Delegates
    
    func didStartLoadingWithRequest(request: Request) {
        self.showLoader()
    }
    
    func didFinishLoadingWithRequest(request: Request, data: NSData, response: NSURLResponse, error: NSError?) {
        let httpResponse: NSHTTPURLResponse = response as! NSHTTPURLResponse
        
        if  httpResponse.statusCode == 200 {
            do {
                let data: [NSDictionary] = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! [NSDictionary]
                for lunch: NSDictionary in data {
                    self.lunches.append(Lunch(dictionary: lunch))
                }
            } catch {
                print("🙉 Error: Cannot parse response!")
            }
        } else {
            print("🙉 Error: Wrong HTTP response: \(httpResponse.statusCode)")
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.hideLoader()
            self.setUI()
        })
    }
    
    func didReceiveDummyData(request: Request) {
        let data: [NSDictionary] = [
            [
                "name": "Spaghetti Bolognese",
                "additives": ["a","b","c"],
                "priceStudent" : "2.55 €",
                "images" : [
                    "http://abload.de/img/spaghetti-bolognese-dfdp11.jpg"
                ]
            ],
            [
                "name": "Pizza Salami",
                "additives": ["a","b","c"],
                "priceStudent" : "1.90 €",
                "images" : []
            ],
            [
                "name": "Wiener Schnitzel",
                "additives": ["a","b","c"],
                "priceStudent" : "3.39 €",
                "images" : [
                    "http://abload.de/img/wiener-schnitzel02sjpx3.jpg"
                ]
            ]
        ]
        
        for lunch: NSDictionary in data {
            self.lunches.append(Lunch(dictionary: lunch))
        }
        
        // Skip main-thread execution here, since no background-thread is invoked
        // when using dummy data
        self.hideLoader()
        self.setUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.splitViewController?.delegate = self
        
        self.request = Request(delegate: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.fetchData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lunches.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LunchCell", forIndexPath: indexPath) as! LunchCell
        let lunch = lunches[indexPath.row] as Lunch
        
        cell.titleLabel.text = lunch.name
        cell.priceLabel.text = lunch.price
        cell.additivesLabel.text = lunch.additivesCount
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailViewController = self.splitViewController?.viewControllers[1] as? LunchDetailViewController
        detailViewController?.lunch = self.lunches[indexPath.row]
    }
}

