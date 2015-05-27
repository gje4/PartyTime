//
//  ChatViewController.swift
//  PartyTime
//
//  Created by George Fitzgibbons on 5/4/15.
//  Copyright (c) 2015 Nanigans. All rights reserved.
//

import Foundation

class ChatViewController : JSQMessagesViewController {
    
    var messages: [JSQMessage] = []
    
    var matchID: String?
    
    var messageListener: MessageListener?
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.senderId = currentUser()!.id
        self.senderDisplayName = currentUser()!.name
        //remove after should work throug later
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
//fetch and display message data from fire base
        
        //check
        if let id = matchID {
            
            fetchMessages(id, {
                messages in
                
                for m in messages {
                    self.messages.append(JSQMessage(senderId: m.senderID, senderDisplayName: m.senderID, date: m.date, text: m.message))
                }
                //update chat window
                self.finishReceivingMessage()
            })
        }
        
    }
    
    //for message listener
    override func viewWillAppear(animated: Bool) {
        if let id = matchID {
            messageListener = MessageListener(matchID: id,
                startDate: NSDate(), callback: {
                    message in
                    self.messages.append(JSQMessage(senderId: message.senderID, senderDisplayName: message.senderID, date: message.date, text: message.message))
                    self.finishReceivingMessage()
            })
        }
    }
    //stop listener when change handler(user)
     override func viewWillDisappear(animated: Bool) {
        messageListener?.stop()
    }
    
    
    //can pass in anything from the user model
    
    func senderDisplayName() -> String! {
        return currentUser()!.id
    }
    func senderId() -> String! {
        return currentUser()!.id
    }
//return shows attending

    
    //return top 3 bands
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        //what person we should we be talking to
        //array of data from the property
        var data = self.messages[indexPath.row]
        //
        return data
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    //bubble controller
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        var data = self.messages[indexPath.row]
        if data.senderId == PFUser.currentUser().objectId {
            return outgoingBubble
        }
        else {
            return incomingBubble
        }
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        //m is message
        let m = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        //then add the actuall message array
        self.messages.append(m)
        //save message to firebase
        
        if let id = matchID {
            saveMessage(id, Message(message: text, senderID: senderId, date: date))
        }
        
        
        
        finishSendingMessage()
        
    }
    
}
