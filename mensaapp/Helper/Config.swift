//
//  Config.swift
//  mensaapp
//
//  Created by Hans Knöchel on 29.03.16.
//  Copyright © 2016 Hans Knoechel. All rights reserved.
//

import Foundation

class Config : NSObject {
    let bundle: Bundle!
    
    override init() {
        bundle = Bundle(path:Bundle.main.path(forResource: "Config", ofType: "bundle")!)
    }
    
    func apiKey() -> NSString? {
        let file = bundle.path(forResource: "Key", ofType: "txt")
        
        if (file == nil) {
            return nil
        }
        
        do {
            return try NSString(contentsOfFile: file!, encoding: String.Encoding.utf8.rawValue)
        } catch {
            print("⚠️ Warning: Config could not be located, using fallback ...")
            return nil
        }        
    }
}
