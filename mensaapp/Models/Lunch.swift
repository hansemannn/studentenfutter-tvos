//
//  Lunch.swift
//  mensaapp
//
//  Created by Hans Knöchel on 29.03.16.
//  Copyright © 2016 Hans Knoechel. All rights reserved.
//

import Foundation

public class Lunch : NSObject {
    
    // MARK: Properties
    var name: String!
    var images: Array<String>!
    var additivesDescription: String! {
        get {
            let prefix: NSString = additives.count == 0 ? "Kein" : additives.count == 1 ? "Ein" : ""
            return prefix.length == 0 ? "\(additives.count) Zusätze" : "\(prefix) Zusatz"
        }
        set {
            self.additivesDescription = newValue
        }
    }
    var rawValue: NSDictionary!
    var price: String!
    var additives: Array<String>!
    
    /**
     Initializes the model with it's properties
     
     - parameter dictionary: The serialized lunch dictionary
     */
    init(dictionary: NSDictionary) {

        super.init()
        self.name = dictionary.objectForKey("name") as! String
        
        if let _additives = dictionary["additives"] {
            if _additives is NSNull || _additives is NSDictionary {
                self.additives = []
            } else {
                self.additives = _additives as! Array<String>
            }
        }
        self.images = dictionary.objectForKey("images") as! Array
        self.rawValue = dictionary

        let _price = self.rawValue["priceStudent"] as! String
        let priceArr = _price.characters.split{$0 == " "}.map(String.init)
        self.price = priceArr[0]
    }
    
    func formatPrice(_price: String) -> NSNumber {
        let priceArr = _price.characters.split{$0 == " "}.map(String.init)

        return NSNumberFormatter().numberFromString(priceArr[0])!
    }
}