//
//  User.swift
//  PartyTime
//
//  Created by George Fitzgibbons on 4/8/15.
//  Copyright (c) 2015 Nanigans. All rights reserved.
//

import Foundation


struct User {
    let id: String
    let name: String
    private let pfUser: PFUser
    
    //access phot for user
    func getPhoto(callback:(UIImage) -> ()) {
        let imageFile = pfUser.objectForKey("picture") as PFFile
        //download from parse then assign it to data, then check and create a uiimage
        imageFile.getDataInBackgroundWithBlock({
            data, error in
            if let data = data {
                callback(UIImage(data: data)!)
            }
        })
    }
    
}
//get data from parse and populate struct
 func pfUserToUser(user: PFUser)->User {
    return User(id: user.objectId, name: user.objectForKey("firstName") as String, pfUser: user)

    
}

func currentUser() -> User? {
    if let user = PFUser.currentUser() {
        return pfUserToUser(user)
    }
    return nil
}



//query parse to get users
//public so its avaible in all files
func fetchUnviewedUsers(callback: ([User]) -> ()) {
    
    //exluced user that you have already seen
    //custom query based on the parse data for Action column
    PFQuery(className: "Action")
    .whereKey("byUser", equalTo: PFUser.currentUser().objectId).findObjectsInBackgroundWithBlock({
        objects, error in
        //use seenIDS
        let seenIDS = map(objects, {$0.objectForKey("toUser")!})
        
        
        //default quary
        //get a user that is not my object id
        PFUser.query()
            //resriction WHERE
            .whereKey("objectID", notEqualTo: PFUser.currentUser().objectId)
            //another where statement.  Users with no action data in parse
            .whereKey("objectID", notContainedIn: seenIDS)
            //get the data now
            .findObjectsInBackgroundWithBlock({
                objects, error in
                if let pfUsers = objects as? [PFUser] {
                    //take an array and add to it
                    let users = map(pfUsers, {pfUserToUser($0)})
                    callback(users)
                }
            })
        
        })
    
    

    
    
}

//Saving information to PArse about the user
    //for Nah usersss
func saveSkip(user: User) {
    //key will automaitcally create column
    let skip = PFObject(className: "Action")
    //action don by the user
    skip.setObject(PFUser.currentUser().objectId, forKey: "byUser")
    //the action he took(who he skipped
    skip.setObject(user.id, forKey: "toUser")
    skip.setObject("skipped", forKey: "type")
    //save all the data now
    skip.saveInBackgroundWithBlock(nil)
}


//Saving information to PArse about the user who like
//for yes usersss
func saveLike(user: User) {
//    //key will automaitcally create column
//    let like = PFObject(className: "Action")
//    //action don by the user
//    like.setObject(PFUser.currentUser().objectId, forKey: "byUser")
//    //the action he took(who he skipped
//    like.setObject(user.id, forKey: "toUser")
//    like.setObject("like", forKey: "type")
//    //save all the data now
//    like.saveInBackgroundWithBlock(nil)
    
    //new function that test for match so we can get mathcs
    PFQuery(className: "Action")
        //do i like the user
    .whereKey("byUser", equalTo: user.id)
        //does this user like me
    .whereKey("toUser", equalTo: PFUser.currentUser().objectId)
        //if so flag as both user liking
    .whereKey("type", equalTo: "liked")
    
    .getFirstObjectInBackgroundWithBlock({
        object, error in
        
        var matched = false
        if object != nil {
            matched = true
            object.setObject("matched", forKey: "type")
            object.saveInBackgroundWithBlock(nil)
            
        }
        let match = PFObject(className:"Action")
        match.setObject(PFUser.currentUser().objectId, forKey: "byUser")
        match.setObject(user.id, forKey: "toUser")
        match.setObject(matched ? "matched" : "liked", forKey: "type")
        match.saveInBackgroundWithBlock(nil)
    })
}




