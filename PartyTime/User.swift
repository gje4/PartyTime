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
private func pfUserToUser(user: PFUser)->User {
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
    
    //get a user that is not my object id
    PFUser.query()
    .whereKey("objectID", notEqualTo: PFUser.currentUser().objectId)
    //get the data now
    .findObjectsInBackgroundWithBlock({
        objects, error in
        if let pfUsers = objects as? [PFUser] {
            //take an array and add to it
            let users = map(pfUsers, { pfUserToUser($0)})
            callback(users)
        }
    })
    
}





