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

class TweetBotDriver {
    
    let failureHandler: (Error) -> Void = {
        print($0.localizedDescription)
        
    }
    
    var tokenKey : String
    var tokenSecret : String
    var pullUserId : String = ""
    var swifter : Swifter
    let callBackURL = URL(string: "swifter://success")!
    var sourceText : [String] = []
   
    
    
    init(tokenKey: String, tokenSecret: String) {
        self.tokenKey = tokenKey
        self.tokenSecret = tokenSecret
        self.swifter =  Swifter(consumerKey: self.tokenKey, consumerSecret: self.tokenSecret)
        
    }
    
     var markov : MarkovChain = MarkovChain()
    
    
    func authorize(sourceUserID: String, count: Int, targetFilePath: String) {
        
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
                    
                    //setup file reader
                    guard let reader = FileReader(path: targetFilePath ) else{
                        exit(0)
                    }
                    //parse source text
                    for line in reader {
                            
                            var separatorSet = " "
                            
                            for word in line.components(separatedBy: separatorSet) {
                                
                                self.sourceText.append(word)
                            }
                    }
                
                //rebuild markov chains with new full text
                self.markov.words = self.sourceText
                
                print("about to generate chain")
                //generate the chain
                
                self.markov.gen2suffixChain()
                
                //build tweet, and post it
                    
                }, failure: self.failureHandler)
                
                //sleep untill chain is most definitely generated
                while(!self.markov.chainGen) {
                    sleep(1)
                }
                
                self.swifter.postTweet(status: self.markov.genTweet(length: 15), success: { _ in
                    
                    print("successful post")
                    
                }, failure: self.failureHandler)
                
                
            }, failure: failureHandler)
        
        }
    }
    
    
    
    
    
    
    
    
    
    

