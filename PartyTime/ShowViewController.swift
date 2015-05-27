//
//  ShowViewController.swift
//  PartyTime
//
//  Created by George Fitzgibbons on 5/11/15.
//  Copyright (c) 2015 Nanigans. All rights reserved.
//

import UIKit

let kAppKey = "6rezkcnp78bwcmasnumws4gb"


class ShowViewController: UIViewController {
    
    var jsonResponse:NSDictionary!
    
    var showArray:[[ShowModel]] = []


    @IBOutlet weak var zipcodeText: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getjambaseJSON("http://api.jambase.com/events")

        
        //navigation
        navigationItem.titleView = UIImageView(image: UIImage(named: "chat-header"))
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"nav-back-button"), style:
            UIBarButtonItemStyle.Plain, target: self, action:"goToPreviousVC:")
        navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
//        //How to make a HTTP Get Request
        
        

    }
    
    
    
    func getjambaseJSON(zipSearch : String){
        var request = NSMutableURLRequest(URL: NSURL(string: "http://api.jambase.com/events?zipCode=95128&radius=50&page=0&api_key=6rezkcnp78bwcmasnumws4gb")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "Get"
        
//        var params = [
//            "api_key" : kAppKey,
//            "radius"  : "50",
//            "zipCode"  : "13021",
//
//        ]

        println(request)
//        println(params)


        var error: NSError?
        println("error")

//        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error)
//        println(request.HTTPBody)

//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//       request.addValue("application/json", forHTTPHeaderField: "Accept")
//        
        var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, err) -> Void in
       

            var conversionError: NSError?
            var jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &conversionError) as? NSDictionary
            println(jsonDictionary)
            if conversionError != nil {
                println(conversionError!.localizedDescription)
                let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("test \(errorString)")
            }
            else {
                if jsonDictionary != nil {
                    self.jsonResponse = jsonDictionary!
                   println("jsonResponse")
            
                }
                else {
                    let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error Could not Parse JSON \(errorString)")
                }
            }
        })
             println(task)
        task.resume()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


    
    //findshows button

    @IBAction func showButtonPressed(zipSearch: UIButton) {
       getjambaseJSON(zipcodeText.text)
}
}
