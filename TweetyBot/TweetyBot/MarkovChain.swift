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
    var suffix : [String : Int] = [:]
    var prefix : [String: [String: Int]] = [:]
    
    var chainGen : Bool = false
    
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
        
        chainGen = true
    }
    
        
        func genTweet(length: Int) -> String {
            
            if (chainGen) {
                
                var Tweet : String = ""
                
                var currentWord = self.words[Int(arc4random_uniform(UInt32(words.count)))]     // output sentence will start with this word
                
                var output: String = currentWord + " "    // start the output sentence
                var endSentence: Bool = false
                
                for current in 0...length {
                    
                    
                    if prefix[currentWord] != nil && currentWord != " " {
                        
                        // Generate the random value
                        let randomValue = Float(arc4random_uniform(1000000)) / 10000
                       
                        // Stores upper value of probability for current suffix word
                        var upperValue: Float = 0
                        
                        // iterate over all suffix words for this prefix
                        for (potentialSuffix, count) in prefix[currentWord]! {
                            
                            // get total suffix words for this prefix
                            let totalSuffixWords = prefix[currentWord]!["📐"]!
                            
                            // exclude the instance of the suffix that contains the suffix total
                            if potentialSuffix != "📐" {
                                
                                //get upper value
                                upperValue += Float(count) / Float( totalSuffixWords ) * 100
                                
                                //Check if suffix is eligible for use
                                if (randomValue < upperValue) {
                                    
                                    // add the potential (now chosen) suffix to the output string
                                    output += potentialSuffix
                                    
                                    // make the potential (now chosen) suffix the new prefix
                                    currentWord = potentialSuffix
                                    
                                    //Check for end of sentence
                                    if output.characters.last == "."  {
                                        break
                                    }
                                    
                                    // Add a space before the next word
                                    output += " "
                                    
                                    // break the loop going over the word probabilities (since we have found a word to add)
                                    break
                                }
                            }
                            
                        }
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                }
                
                if output.characters.last != "." {
                    
                    output.characters.popLast()
                    output += "."
                    
                }
                Tweet = output
                
                return Tweet
                
            } else {
              exit(0)
            }
        }
        
        
        
        
        
        
        
        
        
        
        
        
}
