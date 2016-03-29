//
//  Request.swift
//  mensaapp
//
//  Created by Hans Knöchel on 29.03.16.
//  Copyright © 2016 Hans Knoechel. All rights reserved.
//

import Foundation

@objc protocol RequestDelegate: class {
    optional func didReceiveDummyData(request: Request)
    optional func didStartLoadingWithRequest(request: Request)
    optional func didFinishLoadingWithRequest(request: Request, data: NSData, response: NSURLResponse, error: NSError?)
}

class Request : NSObject, NSURLSessionDelegate, RequestDelegate {
    
    weak var delegate: RequestDelegate!
    var config: Config!
    
    init(delegate: RequestDelegate) {
        super.init()
        self.delegate = delegate
        self.config = Config()
    }
    
    func load(url: String) {
        self.delegate.didStartLoadingWithRequest!(self)
        
        if (config.getAPIKey() == nil) {
            self.delegate.didReceiveDummyData!(self)
            return;
        }
        
        let urlPath = NSURL(string: url)
        let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfiguration.HTTPAdditionalHeaders = ["Authorization" : config.getAPIKey()!]
        
        let session = NSURLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        
        let task = session.dataTaskWithURL(urlPath!, completionHandler: {(data, response, error) in
            self.delegate.didFinishLoadingWithRequest!(self, data:data!, response: response!, error: error)
        })
        task.resume()
    }
}