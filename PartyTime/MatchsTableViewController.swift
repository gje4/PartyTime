//
//  MatchsTableViewController.swift
//  PartyTime
//
//  Created by George Fitzgibbons on 4/23/15.
//  Copyright (c) 2015 Nanigans. All rights reserved.
//

import UIKit

class MatchsTableViewController: UITableViewController {
    
    //for matchs an array
    var matches: [Match] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
    
    //load evertyime screen shows up
    
    override func  viewWillAppear(animated: Bool) {
        
        
        
        //navigation
        navigationItem.titleView = UIImageView(image: UIImage(named: "chat-header"))
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"nav-back-button"), style:
            UIBarButtonItemStyle.Plain, target: self, action:"goToPreviousVC:")
        navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: true)
        
        
        //get matches
        fetchMatchs({
            matches in
            self.matches = matches
            //reload data
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func goToPreviousVC(button: UIBarButtonItem) {
        pageController.goToPreviousVC()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return matches.count
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       //display cell
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as UserCell

        // Configure the cell...
//configure the matchs user data
        let user = matches[indexPath.row].user
        
        cell.nameLabel.text = user.name
        user.getPhoto({
            image in
            cell.avatarImageView.image = image
            })
        
        
        return cell
    }
  
override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //do not persist the selection of a cel
    
    //go to the chat view controller
    let vc = ChatViewController()
    
    //create a match id to store conversation
    let match = matches[indexPath.row]
    //id
    vc.matchID = match.id
    println(vc.matchID)
    //title should be show and name
    vc.title = match.user.name
    navigationController?.pushViewController(vc, animated: true)
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
