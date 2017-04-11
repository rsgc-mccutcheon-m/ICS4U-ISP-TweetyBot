//
//  ViewController.swift
//  TweetyBot
//
//  Created by Jarvis on 2017-02-13.
//  Copyright © 2017 Clutch Design Solutions. All rights reserved.
//

import Cocoa
import SwifterMac
import Accounts


class ViewController: NSViewController {
    
    var filePath : String = "/Users/student/Documents/Clean Repos/ICS4U-ISP-TweetyBot/TweetyBot/TweetyBot/sourceText.txt"
    var sourceText : [String] = []
    var twitGenSource : String = ""
    
    //    var TWITTER_CONSUMER_KEY = "6zPev1iQURmmrdUf717P7Ro8g"
    //    var TWITTER_CONSUMER_SECRET = "5zNYBfDAZHywOPYy27HfTQY4mIyJyi1MGSAqSpefxDBuiflhyM"
    
    dynamic var tweets : [Tweet] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup a failure event handler
        let failureHandler: (Error) -> Void = {
            print($0.localizedDescription)
            
        }
        
        var markov : MarkovChain
        
        // Do any additional setup after loading the view.
        
        guard let reader = FileReader(path:filePath ) else{
            exit(0)
        }
        
        for line in reader {
            
            var separatorSet = " "
            
            for word in line.components(separatedBy: separatorSet) {
                
                sourceText.append(word)
            }
        }
        
        //print(sourceText)
        
        markov = MarkovChain(words: sourceText)
        
        //markov.genStndChain()
        //markov.gen2suffixChain()
        
        //print(markov.prefix)
        
        //var outputTweet = markov.genTweet(length: 10)
        //print("TWEET FINISHED BUILDING")
        //print(outputTweet)
        
        
        
        //MARK: Twitter Connect
        
        //var swifter = Swifter(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)
        let swifter = Swifter(consumerKey: "Wk7pfyd4vGPKS1gDVDbwxLIMU", consumerSecret: "8sTxiRpvmKg3gv4rS2YwsPbiTssnUvc8qrSzCPJgQxr1VcgIbf")
        let callBackURL = URL(string: "swifter://success")!
        //authorize, then load up the tweets on the homepage
        swifter.authorize(with: callBackURL , success: { _ in
            swifter.getTimeline(for: "4749161120", count: 500, trimUser: true, contributorDetails: false, includeEntities: false, success: { statuses in
                
                guard let tweets = statuses.array else {
                    
                    print( "failed to put stati into array")
                    
                    return }
                
                for tweet in tweets {
                    
                    //if text entry for that post isnt nil, add it to the source text file
                    if let testStringUnwrap : String = tweet["text"].string {
                       self.twitGenSource += testStringUnwrap
                    }
                }
                //update the source text file
                do {
                    try self.twitGenSource.write(toFile: self.filePath, atomically: false, encoding: String.Encoding.utf8)
                
                } catch {
                    print("failed to write tweets to text file")
                    exit(0)
                }

            }, failure: failureHandler)
            
            //Re-extract source text
            guard let reader = FileReader(path:self.filePath ) else{
                exit(0)
            }
            
            for line in reader {
                
                var separatorSet = " "
                
                for word in line.components(separatedBy: separatorSet) {
                    
                    self.sourceText.append(word)
                }
            }
            
            markov.words = self.sourceText
            markov = MarkovChain(words: self.sourceText)
            markov.gen2suffixChain()
            var outputTweet = markov.genTweet(length: 10)
            print("TWEET FINISHED BUILDING")
            print(outputTweet)
            
            swifter.postTweet(status: outputTweet, success: { _ in
                
                print("successful post")
                
            }, failure: failureHandler)
            
        }, failure: failureHandler)
        
        
        
        
        //        for tweet in tweets {
        //            do {
        //                print(tweets)
        //                print(tweet.text!)
        //            } catch {
        //                print("tweet failed")
        //
        //            }
        //        }
        
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}

class Tweet: NSObject {
    
    var name: String!
    var text: String!
    
}

