//
//  LoginViewController.swift
//  PartyTime
//
//  Created by George Fitzgibbons on 4/8/15.
//  Copyright (c) 2015 Nanigans. All rights reserved.
//

import UIKit
import TwitterKit
class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let logInButton = TWTRLogInButton(logInCompletion: {
//            (session: TWTRSession!, error: NSError!) in
//            // play with Twitter session
//        })
//        logInButton.center = self.view.center
//        self.view.addSubview(logInButton)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    @IBAction func pressedFBLogin(sender: UIButton) {
        PFFacebookUtils.logInWithPermissions(["public_profile",
            "user_about_me", "user_birthday"], block: {
                user, error in
                
                if user == nil {
                    println("the user canceled fb login")
                    //add uialert
                    
                    return
                    
                }
                    //new user
                else if user.isNew {
                    println("user singed up through FB")
                    
                    //get information from fb then save to parse
                    FBRequestConnection.startWithGraphPath("/me?fields=picture,first_name,birthday,gender",  completionHandler: {
                        connection, result, error in
                        //print results
                        println(result)
                        //result dictionary about user
                        var r = result as NSDictionary
                        //prnt dictionary
                        println(NSDictionary)
                        //match parse column with what fb sends
                        user["firstName"] = r["first_name"]
                        user["gender"] = r["gender"]
                        //r = result, then key into using picture.  Then key into url using the data
                     let pictureURL = ((r["picture"] as NSDictionary)["data"] as NSDictionary) ["url"] as String
                        
                        //using the image url to create image
                        let url = NSURL(string: pictureURL)
                        let request = NSURLRequest(URL:url!)
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:
                            {
                                response, data, error in
                                
                                //create a pf file that holds image data
                                let imageFile = PFFile(name: "avatar.jpg", data: data)
                                user["picture"] = imageFile
                                
                                
                                //save all data to parse

                                user.saveInBackgroundWithBlock({
                                    success, error in
                                    println(success)
                                    println(error)
                                    
                                })
                                
                                
                            })
                        //date formater
                        var dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "MM/dd/yyyy"
                        //birtgday show
                        user["birthday"] = dateFormatter.dateFromString(r["birthday"] as String)
              
                        }
                    )
                }
                else {
                    println("login, through FB")
                }
                //go to start view
                
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardsNavController") as? UIViewController
                
                self.presentViewController(vc!, animated: true, completion: nil)
                })
                
      
        
        
        
    }
    

}
