//
//  MarkovChain.swift
//  TweetyBot
//
//  Created by Jarvis on 2017-02-23.
//  Copyright © 2017 Clutch Design Solutions. All rights reserved.
//

import Foundation

class MarkovChain {
    
    var words : [String] = []
    var suffix = [String : Int] = [:]
    var prefix = [String: [String: Int]] = [:]
    
    init (words: [String]) {
        
      self.words = words
        
    }
    
    func genChain() {
        
        for (index, word) in self.words.enumerated() {
            
            // Stop loop before no suffix remains
            if index == words.count - 1 {
                break
            }
            
            // when the current word from the input array is not in the prefix dictionary at all & skip blank entries
            if self.prefix[word] == nil && word != " " {
                
                self.suffix[words[index + 1]] = 1    // add a count of 1 for the suffix (word following current word in input)
                self.suffix["📐"] = 1                // triangular ruler key represents total # of suffixs count
                self.prefix[word] = suffix           // current word from input array becomes key in prefix dictionary with value of suffix dictionary just created
                
            } else {
                
                // add 1 to total in suffix dictionary
                prefix[word]!["📐"]! += 1
                
                // does current word exist as a suffix already?
                if prefix[word]![words[index + 1]] == nil {         // does not exist, so create and set to 1
                    prefix[word]![words[index + 1]] = 1
                    
                } else {                                            // does exist, so increment by 1
                    prefix[word]![words[index + 1]]! += 1
                }
            }
            
            // wipe out the suffix dictionary for next iteration, so it starts blank
            suffix = [:]
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
