//
//  ViewController.swift
//  TweetyBot
//
//  Created by Jarvis on 2017-02-13.
//  Copyright © 2017 Clutch Design Solutions. All rights reserved.
//

import Cocoa



class ViewController: NSViewController {

    var filePath : String = "/Users/student/Documents/Clean Repos/ICS4U-ISP-TweetyBot/TweetyBot/TweetyBot/sourceText.txt"
    var sourceText : [String] = []
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        guard let reader = FileReader(path:filePath ) else{
            exit(0)
        }
        
        for line in reader {
            
            for word in line.components(separatedBy: " ") {
                
                sourceText.append(word)
            }
        }
        
        print(sourceText)

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

