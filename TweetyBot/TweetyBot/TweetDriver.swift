//
//  TweetDriver.swift
//  TweetyBot
//
//  Created by Jarvis on 2017-02-27.
//  Copyright © 2017 Clutch Design Solutions. All rights reserved.
//

import Foundation
import SwifterMac
import Accounts

class TweetDriver {
    
    let failureHandler: (Error) -> Void = {
        print($0.localizedDescription)
        
    }
    
    var tokenKey : String
    var tokenSecret : String
    var pullUserId : String
    var swifter : Swifter
    let callBackURL = URL(string: "swifter://success")!
    
    
    init(tokenKey: String, tokenSecret: String, pullUserId: String) {
        self.tokenKey = tokenKey
        self.tokenSecret = tokenSecret
        self.pullUserId = pullUserId
        self.swifter =  Swifter(consumerKey: self.tokenKey, consumerSecret: self.tokenSecret)
        
    }
    

    
    func authorizeAndPullText(sourceUserID: String, count: Int, targetFilePath: String) {
    
        var tempSourceString = ""
        
        swifter.authorize(with: callBackURL , success: { _ in
            self.swifter.getTimeline(for: sourceUserID, count: count, trimUser: true, contributorDetails: false, includeEntities: false, success: { statuses in
                
                guard let tweets = statuses.array else {
                    
                    print( "failed to put stati into array")
                    
                    return }
                
                for tweet in tweets {
                    
                    //if text entry for that post isnt nil, add it to the source text file
                    if let testStringUnwrap : String = tweet["text"].string {
                        tempSourceString += testStringUnwrap
                    }
                }
                //update the source text file
                do {
                    try tempSourceString.write(toFile: targetFilePath, atomically: false, encoding: String.Encoding.utf8)
                    
                } catch {
                    print("failed to write tweets to text file")
                    exit(0)
                }
                
            }, failure: self.failureHandler)
        }, failure: failureHandler)
    }
    
    func authorizeAndPost(post: String) {
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
}
