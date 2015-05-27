//
//  shows.swift
//  PartyTime
//
//  Created by George Fitzgibbons on 5/11/15.
//  Copyright (c) 2015 Nanigans. All rights reserved.
//

import Foundation


func getShowData(){
    let url = NSURL(string: "http://api.jambase.com/events?zipCode=95128&radius=50&page=0&api_key=\(kAppKey)")
    let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
        var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
        println(stringData)
        println(response)
    })
    task.resume()

    
}

struct ShowModel {
    var Id:String
    var Name:String
    var Artists:String

    
    
}



//get data from api and populate struct

class DataController {
    
    //array of tuples
    class func jsonshowsInZipCode (json :
        NSDictionary) -> [(date: String, idValue: String)] {
            
            //array for results from the search
            
            var showsInZipeSearchResults:[(date : String, idValue: String)] = []
            
            var searchResult: (date: String, idValue : String)
            
            //check for returns
            if json["hits"] != nil {
                
                let results:[AnyObject] = json ["hits"]! as [AnyObject]
                
                for itemDictionary in results {
                    
                    
                    //loop through looking at id to pull id data
                    if itemDictionary["Id"] != nil {
                        if itemDictionary["Venue"] != nil {
                            let fieldsDictionary = itemDictionary["Venue"] as NSDictionary
                            if fieldsDictionary["Name"] != nil {
                                let idValue:String = itemDictionary["Id"]! as String
                                let name:String = fieldsDictionary["Name"]! as String
                                
                                
                                //tupale to be used
                                searchResult = (date : name, idValue : idValue)
                                
                                //add item to array
                                showsInZipeSearchResults += [searchResult]
                            }
                        }
                    }
                }
            }
            return showsInZipeSearchResults
    }
}





