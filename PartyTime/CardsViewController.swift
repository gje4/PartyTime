//
//  CardsViewController.swift
//  PartyTime
//
//  Created by George Fitzgibbons on 4/1/15.
//  Copyright (c) 2015 Nanigans. All rights reserved.
//

import UIKit

class CardsViewController: UIViewController, SwipeViewDelegate {

   //card struc to combin the two views
    struct Card {
        let cardView: CardView
        let swipeView: SwipeView
        //and a specfic user
        let user:User
        
    }
    
    
    
    //stack cards constants
    let frontCardTopMargin: CGFloat = 0
    let backCardTopMargin: CGFloat = 10
    @IBOutlet weak var cardStackView: UIView!
    
    
    //vars
    var backCard: Card?
    var frontCard: Card?
    
    var users: [User]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //back ground
        cardStackView.backgroundColor = UIColor.clearColor()

        //use frame func to add back card slighlt off the cardstack view
//        backCard = SwipeView(frame: createCardFrame(backCardTopMargin))
//refactor to use card
//        backCard = createCard(backCardTopMargin)
//        
//        //delgate
//        //no longer needed set at card level
////        backCard!.delegate = self
//        
//        cardStackView.addSubview(backCard!.swipeView)
//    
//        //front card
//        frontCard = createCard(frontCardTopMargin)
//        //swipe delegate so it has contorl
//        
//        cardStackView.addSubview(frontCard!.swipeView)
        
        
        //call fucntion from user to get user to show
        fetchUnviewedUsers(
            {
                //check for a user and get his info
                users in
                self.users = users
                println(self.users)
                
                //get card for the above user
                
                if let card = self.popCard() {
                    self.frontCard = card
                    self.cardStackView.addSubview(self.frontCard!.swipeView)
                }
                //if two or more user get another card made
                
                if let card = self.popCard() {
                self.backCard = card
                    self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
                    //insert below the front card
                    self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
                    
                }
                
        })
    
    }
    
override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    navigationItem.titleView = UIImageView(image: UIImage(named: "nav-header"))
    
    
    let leftBarButtonItem = UIBarButtonItem(image: UIImage (named: "nav-back-button"), style: UIBarButtonItemStyle.Plain,
        target: self, action: "goToProfile:")
    navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    //helper func (when card and swipe where combined)
    
//    private func createCardFrame(topMargin: CGFloat) -> CGRect {
//        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
//    }
    
    //hleper function for view to return a card isntance(card and swipe)
        //frame
    private func createCardFrame(topMargin: CGFloat) -> CGRect {
        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width,
            height: cardStackView.frame.height)
    }
        //now make the card
    private func createCard(user: User) -> Card {
        let cardView = CardView()
        //have to give the card a user (name pic)
        
        //user class user has name and image
        cardView.name = user.name
        user.getPhoto({
            image in cardView.image = image
        })
        
        
        
        let swipeView = SwipeView(frame: createCardFrame(0))
        swipeView.delegate = self
        swipeView.innerView = cardView
        //card struct instance
        return Card(cardView: cardView, swipeView: swipeView, user: user)

    }
    
    //private helper function.  create a card based on the users array.
    private func popCard() -> Card? {
        if users != nil && users?.count > 0 {
            return createCard(users!.removeLast())
        }
        return nil
    }
    
    
    private func switchCards() {
        if let card = backCard {
            frontCard = card
            UIView.animateWithDuration(0.2, animations: {
                self.frontCard!.swipeView.frame = self.createCardFrame(self.frontCardTopMargin)
 
        })
    }
        if let card = self.popCard() {
            self.backCard = card
            self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
            self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
        }
    }
    //call bar buttons
    func goToProfile(button: UIBarButtonItem) {
        pageController.goToPreviousVC()
    }
    
    //Mark: SwipeViewDelegate
    func  swipedLeft() {
        println("swipe left")
        //get value from card then remove it
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            switchCards()
        }
    }
    
     func swipedRight() {
        println("swipe Right")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            switchCards()

        }

    }
    
    
    
    

}
