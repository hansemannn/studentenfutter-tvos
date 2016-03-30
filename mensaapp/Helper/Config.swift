//
//  Config.swift
//  mensaapp
//
//  Created by Hans Knöchel on 29.03.16.
//  Copyright © 2016 Hans Knoechel. All rights reserved.
//

import Foundation

class Config : NSObject {
    let bundle: NSBundle!
    
    override init() {
        bundle = NSBundle(path:NSBundle.mainBundle().pathForResource("Config", ofType: "bundle")!)
    }
    
    func apiKey() -> NSString? {
        let file = bundle.pathForResource("Key", ofType: "txt")
        
        if (file == nil) {
            return nil
        }
        
        do {
            return try NSString(contentsOfFile: file!, encoding: NSUTF8StringEncoding)
        } catch {
            print("⚠️ Warning: Config could not be located, using fallback ...")
            return nil
        }        
    }
}