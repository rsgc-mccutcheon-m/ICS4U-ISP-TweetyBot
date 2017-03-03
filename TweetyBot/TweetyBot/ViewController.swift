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
    
    var TWITTER_CONSUMER_KEY = "6zPev1iQURmmrdUf717P7Ro8g"
    var TWITTER_CONSUMER_SECRET = "5zNYBfDAZHywOPYy27HfTQY4mIyJyi1MGSAqSpefxDBuiflhyM"
    
    dynamic var tweets : [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        markov.genChain()
        
        var tweet = markov.genTweet(length: 10)
        
        
        //MARK: Twitter Connect
        
        var swifter = Swifter(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)
        
        
        swifter.author
        
        
        
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

