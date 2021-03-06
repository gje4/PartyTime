//
//  ViewController.swift
//  PartyTime
//
//  Created by George Fitzgibbons on 3/30/15.
//  Copyright (c) 2015 Nanigans. All rights reserved.
//

import UIKit
import MoPub


//constant for first screen
let pageController = ViewController(transitionStyle:UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)

//go between pages
class ViewController: UIPageViewController, UIPageViewControllerDataSource, MPAdViewDelegate
 {

    // TODO: Replace this test id with your personal ad unit id
    var adView: MPAdView = MPAdView(adUnitId: "51b0c5cfdf01473a96c7d624160e325f", size: MOPUB_BANNER_SIZE)

    //call to change views
    let cardsVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CardsNavController") as UIViewController
    
//let profileVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProfileNavController") as UIViewController
    let profileVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("showNavController") as UIViewController

   
    let matchesVC: UIViewController! = UIStoryboard(name:"Main" , bundle: nil).instantiateViewControllerWithIdentifier("MatchsNavController")as UIViewController
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //mopub
        
        super.viewDidLoad()
        self.adView.delegate = self
        self.adView.frame = CGRectMake(0, self.view.bounds.size.height - MOPUB_BANNER_SIZE.height,
            MOPUB_BANNER_SIZE.width, MOPUB_BANNER_SIZE.height)
        self.view.addSubview(self.adView)
        self.adView.loadAd()
        
        // Function for failed "loading" of an ad.
        func adViewDidFailToLoadAd(view: MPAdView!) {
            println("Failed to load ad")
        }
        func adViewDidLoadAd(view: MPAdView!) {
            println("The ad loaded")
        }
        func viewControllerForPresentingModalView() -> UIViewController {
            return self
        }
        
        view.backgroundColor = UIColor.whiteColor()
        dataSource = self

        //grab the view controller you want to set
        self.setViewControllers([cardsVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    //view controller functions
    func goToNextVC() {
        
        let nextVC = pageViewController(self, viewControllerAfterViewController: viewControllers[0] as UIViewController)!
        
        setViewControllers([nextVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
    }
    
    func goToPreviousVC() {
        let previousVC = pageViewController(self, viewControllerBeforeViewController: viewControllers[0] as UIViewController)!
        setViewControllers([previousVC], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
    }
    
    //MARK: UIPAGEViewControllerDataSource
    //before
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case cardsVC:
            return profileVC
        case profileVC:
            return nil
        case matchesVC:
        return cardsVC

        default:
            return nil
            
            
        }
    
    }
    //after
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        switch viewController {
        case cardsVC:
            return matchesVC
        case profileVC:
            return cardsVC
            
        default:
            return nil
        }
        }
    
    func viewControllerForPresentingModalView() -> UIViewController {
        return self
    }
    
    


}

