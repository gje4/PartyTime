//
//  Message.swift
//  PartyTime
//
//  Created by George Fitzgibbons on 5/6/15.
//  Copyright (c) 2015 Nanigans. All rights reserved.
//

import Foundation


struct Message {
    let message: String
    let senderID: String
    let date: NSDate
    
}
//realtime update
//look for new data in firebase
class MessageListener {
    var currentHandle: UInt?
    
    init (matchID: String, startDate: NSDate, callback:(Message)->()) {
        //firebase instants, query for most recent
        let handle = ref.childByAppendingPath(matchID).queryOrderedByKey().queryStartingAtValue(dataFormatter().stringFromDate(startDate)).observeEventType(FEventType.ChildAdded, withBlock: {
            //sees something was added using chiladded
            snapshot in
            //convert to message
            let message = snapshotToMessage(snapshot)
            callback(message)
        })
        //storing handle name so we know who sent
        self.currentHandle = handle
    }
    //stop listening if we move away from chat
    func stop() {
        if let handle = currentHandle {
            ref.removeObserverWithHandle(handle)
            currentHandle = nil
        }
    }
}
//firebase object to be able to call the firebase api
private let ref = Firebase(url: "https://party-time.firebaseio.com/messages")
private let dateFormat = "yyyyMMddHHmmss"

//helper function

//date formater
private func dataFormatter() -> NSDateFormatter {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter
}


//function we can call anywhere to save messages to firebase
func saveMessage(matchID: String, message: Message) {
    ref.childByAppendingPath(matchID).updateChildValues([dataFormatter().stringFromDate(message.date):
        ["message" : message.message, "sender" : message.senderID]])
}
//function we can call anywhere to grab messages from firebase
    //get data from firebase and formate in struct message
private func snapshotToMessage(snapshot: FDataSnapshot) -> Message
{
    let date = dataFormatter().dateFromString(snapshot.key)
    let sender = snapshot.value["sender"] as? String
    let text = snapshot.value["message"] as? String
    return Message(message: text!, senderID: sender!, date: date!)
}
    //firebase message data that we can use anywehre in the messge structe
func fetchMessages(matchID: String, callback: ([Message]) -> ())
{
    //return the last 25 using the about snapshot
    ref.childByAppendingPath(matchID).queryLimitedToFirst(25).observeSingleEventOfType(FEventType.Value,
        withBlock: {
            snapshot in
            var messages = Array<Message>()
            let enumerator = snapshot.children
            while let data = enumerator.nextObject() as? FDataSnapshot {
                messages.append(snapshotToMessage(data))
            }
            callback(messages)
    })
}