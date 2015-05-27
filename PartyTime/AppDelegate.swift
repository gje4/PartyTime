//
//  AppDelegate.swift
//  PartyTime
//
//  Created by George Fitzgibbons on 3/30/15.
//  Copyright (c) 2015 Nanigans. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import MoPub
import TwitterKit

//mat keys
let Mat_Advertiser_Id   = "177134"
let Mat_Conversion_Key  = "49cee6203a0578a6e17e9dc860bb4d9"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//        // Initialize Parse.
        Parse.setApplicationId("W06PhkRrgZwjdhLb4aQsZEOswQ5fswBnmnrKgvTu",
        clientKey:"icUhjExVlMrwUTSw63EIEdlguw55d6QJaLB9RIDX")
        
//        // [Optional] Track statistics around application opens.
//        [PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)];
        
        //MAt
        MobileAppTracker.initializeWithMATAdvertiserId(Mat_Advertiser_Id, MATConversionKey:Mat_Conversion_Key);
        MobileAppTracker.setAppleAdvertisingIdentifier(ASIdentifierManager.sharedManager().advertisingIdentifier, advertisingTrackingEnabled: ASIdentifierManager.sharedManager().advertisingTrackingEnabled);
        
        MobileAppTracker.setDebugMode(false);
        MobileAppTracker.setAllowDuplicateRequests(true);

        
        PFFacebookUtils.initializeFacebook()
        
        //twitter
        Fabric.with([MoPub()])
        Fabric.with([MoPub(), Twitter()])
        


        
//determine if it is a new user or a logged in user
            //store in parse and locally
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var initialViewController:UIViewController
        
        if currentUser() != nil {
            //transistion style
            initialViewController = pageController
            
//            initialViewController = storyboard.instantiateViewControllerWithIdentifier("PageController") as UIViewController
            println("returning user")
            
        }
        //else pull up login
        else {
            

                initialViewController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as UIViewController

            }
        
        //update windows so it knows whats up
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        
        //test object to save in parse
//        let testObject = PFObject(className: "TestObject")
//        testObject["foo"] = "bar"
//        testObject.save()

        
        return true
    }

    //functiong to send data to parse and fb
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession: PFFacebookUtils.session())
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
        
        MobileAppTracker.measureSession();
    }

    func applicationWillTerminate(application: UIApplication) {
        PFFacebookUtils.session().close()

        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Nanigans.PartyTime" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("PartyTime", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("PartyTime.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }

}

