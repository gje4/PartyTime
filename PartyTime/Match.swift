//
//  Match.swift
//  PartyTime
//
//  Created by George Fitzgibbons on 5/1/15.
//  Copyright (c) 2015 Nanigans. All rights reserved.
//

import Foundation


struct Match {
    let id: String
    let user: User
}


//find out what matchs the user has
func fetchMatchs(callBack: ([Match]) -> ()) {
    //look for user
    PFQuery(className: "Action")
    .whereKey("byUser", equalTo: PFUser.currentUser().objectId)
    .whereKey("type", equalTo: "matched")
        .findObjectsInBackgroundWithBlock({
         objects, error in
        //check to make sure there objects
        if let matches = objects as? [PFObject] {
            //map the objects
            let matchedUsers = matches.map ({
                (object) -> (matchID: String, userID: String) in
                (object.objectId, object.objectForKey("toUser") as String)
            })
            
            let userIDs = matchedUsers.map({$0.userID})
            println(userIDs)
            //get infromation about the userIDS
            
            PFUser.query()
            .whereKey("objectId", containedIn: userIDs)
            //now pull data
            .findObjectsInBackgroundWithBlock({
                objects, error in
                //let users be the results as an arry (pfuser array)
                if let users = objects as? [PFUser] {
                    var users = reverse(users)
                    var m:[Match] = []
                    //loop thorugh resutls
                    for (index, user) in enumerate(users) {
                        m.append(Match(id: matchedUsers[index].matchID, user: pfUserToUser(user)))
                    }
                    callBack(m)
                }
            })
}
})
}