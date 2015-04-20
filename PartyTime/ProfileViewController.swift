//
//  ProfileViewController.swift
//  PartyTime
//
//  Created by George Fitzgibbons on 4/8/15.
//  Copyright (c) 2015 Nanigans. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

//    @IBOutlet weak var imageView: UIImageView!
//    
//    @IBOutlet weak var nameLabel: UILabel!

    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    

    
    
    //    add animation and pics to the view when it appears
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //over ride the title
        navigationItem.titleView = UIImageView(image: UIImage(named: "profile-header"))
        
        //            //barbutton item
        //            let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToCards:")
        //
        //        //navigation for the bar button
        //            navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: true)
        
        let leftBarButtonItem = UIBarButtonItem(image: UIImage (named: "nav-back-button"), style: UIBarButtonItemStyle.Plain,
            target: self, action: "goToProfile:")
        navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
//optinal

     
        nameLabel.text = currentUser()?.name
        //acess current user data
        currentUser()?.getPhoto({
            image in
            //stay in uimage
            self.imageView.layer.masksToBounds = true
            //fill uimage
            self.imageView.contentMode = .ScaleAspectFill
            self.imageView.image = image
        })
        
        
    
    
    }
    
////    add animation and pics to the view when it appears
//        override func viewWillAppear(animated: Bool) {
//            super.viewWillAppear(animated)
//    
//            //over ride the title
//            navigationItem.titleView = UIImageView(image: UIImage(named: "profile-header"))
//    
////            //barbutton item
////            let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav-back-button"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToCards:")
////    
////        //navigation for the bar button
////            navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: true)
//            
//            let leftBarButtonItem = UIBarButtonItem(image: UIImage (named: "nav-back-button"), style: UIBarButtonItemStyle.Plain,
//                target: self, action: "goToProfile:")
//            navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
//            
//        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

//helper function
    func goToCards(button: UIBarButtonItem) {
        pageController.goToNextVC()
    
    }

}
