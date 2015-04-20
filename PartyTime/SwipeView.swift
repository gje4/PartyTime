//
//  SwipeView.swift
//  PartyTime
//
//  Created by George Fitzgibbons on 3/31/15.
//  Copyright (c) 2015 Nanigans. All rights reserved.
//

import Foundation
import UIKit


//use delegate to inform all other views about swip
protocol SwipeViewDelegate: class {
    func swipedLeft()
    func swipedRight()
}



class SwipeView: UIView {
    
    
    //keep track of state and direction so you know if it is yes or no
    enum Direction {
        case None
        case Left
        case Right
    }
    //weak makes this var more memory effiecient
    weak var delegate: SwipeViewDelegate?
    
    //need to de couple so they are no need for each other
//    private let card: CardView = CardView()

    //modular
    var innerView: UIView? {
        // after value set do something
        didSet {
            if let v = innerView {
                addSubview(v)
                v.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            }
        }
    }
    
    //swipe ability, pan calls function whenever its touched
    private var originalPoint: CGPoint?
    
    
    //override init
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
        
    }
    
    override  init(frame: CGRect) {
        super.init(frame: frame)
    initialize()
    }
    
    override init() {
        super.init()
    initialize()
    }
    
    //shared init
    private func initialize() {
        //change back to clear
        self.backgroundColor = UIColor.redColor()
//        addSubview(card)
        
        //func for the swipe
        
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "dragged:"))
        
        //keep the view the same de couple form card
//        card.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)

        originalPoint = center
        
        
//        setConstraints()
        //no auto resising
//        card.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    //func for the gragged
    func dragged(gestureRecognizer: UIPanGestureRecognizer) {
        
        //adding the distance to the orgianl point
        let distance = gestureRecognizer.translationInView(self)
//        println("Distance x:\(distance.x) y: \(distance.y)")
        
        
        //state, what is it currently doing (began, changed-moving, ended-released)
        
        switch gestureRecognizer.state {
        case UIGestureRecognizerState.Began:
            originalPoint = center
            
        case UIGestureRecognizerState.Changed:
            
            //update so that we know how far it was swipped
            let rotationPercentage = min(distance.x/(self.superview!.frame.width/2),1)
            
            let rotationAngle = (CGFloat(2*M_PI/16)*rotationPercentage)
            transform = CGAffineTransformMakeRotation(rotationAngle)
            
            center = CGPointMake(originalPoint!.x + distance.x, originalPoint!.y + distance.y)

        case UIGestureRecognizerState.Ended:
            
            //check to see if it is swipped a quarter and reset side
            //didnt swip far enough
            if abs(distance.x) < frame.width/4 {
                resetViewPositionAndTransformations()

            }
                //move to the right or left.  If distance is greater than 0 go to the right, if not go the left
            else {
                swipe(distance.x > 0 ? .Right : .Left)
            
            }
        default:
            println("Default trigged for GestureRecognizer")
            break

            
        }
        
        

    }
    
    //tell what direction the card was swipped
    
    func swipe(s:Direction) {
        
        //.none = .direction(direction already diffened)
        if s == .None {
            return
        }
        var parentWidth = superview!.frame.size.width
        if s == .Left {
            parentWidth *= -1
        }
        
        
        //use completetion to detemine when it is swiped right or left
        
        UIView.animateWithDuration(0.2, animations: {
            self.center.x = self.frame.origin.x + parentWidth},
            completion: {
                success in
        //if delegate (swipeview delagete) is there make it equal to d
                if let d = self.delegate {
                    //call funcitons
                    s == .Right ? d.swipedRight() : d.swipedLeft()
                    
                    
                }
        
                })
        //if it is swipped to left remove from screen
//        UIView.animateWithDuration(0.2, animations: { () -> Void
//            in self.center.x = self.frame.origin.x + parentWidth
//        })
        
    }
    
    
    //snapp back
    private func resetViewPositionAndTransformations() {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.center = self.originalPoint!
            self.transform = CGAffineTransformMakeRotation(0)
        })
    }
    
    
//    private func setConstraints() {
//        
//    //same contraints of cardview, do want this to be bigger than the card
//        addConstraint(NSLayoutConstraint(item: card, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: card, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: card, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
//        addConstraint(NSLayoutConstraint(item: card, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0))
//    
//    }
    
}