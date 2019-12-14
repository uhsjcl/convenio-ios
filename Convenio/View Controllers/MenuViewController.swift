//
//  MenuViewController.swift
//  Convenio
//
//  Created by Anshay Saboo on 10/20/19.
//  Copyright © 2019 Anshay Saboo. All rights reserved.
//

import UIKit
import SideMenuSwift

class Preferences {
    static let shared = Preferences()
    var enableTransitionAnimation = false
}

class MenuViewController: UIViewController {
    
    @IBOutlet var trailingConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // gradient background
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(rgb:0x2ecc71).cgColor,
            UIColor(rgb: 0x27ae60).cgColor
        ]
        gradient.frame = self.view.bounds
        self.view.layer.insertSublayer(gradient, at: 0)
        
        // load up view controllers
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "FeedViewController")
        }, with: "Feed")

        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "ScheduleViewController")
        }, with: "Schedule")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "MapViewController")
        }, with: "Map")
        
        sideMenuController?.cache(viewControllerGenerator: {
            self.storyboard?.instantiateViewController(withIdentifier: "HuntMainViewController")
        }, with: "Hunt")
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        let sidemenuBasicConfiguration = SideMenuController.preferences.basic
        let showPlaceTableOnLeft = (sidemenuBasicConfiguration.position == .under) != (sidemenuBasicConfiguration.direction == .right)
        trailingConstraint.constant = showPlaceTableOnLeft ? SideMenuController.preferences.basic.menuWidth - size.width : 0
        view.layoutIfNeeded()
    }
    
    func transitionToViewController(id: String) {
        sideMenuController?.setContentViewController(with: id, animated: Preferences.shared.enableTransitionAnimation)
        sideMenuController?.hideMenu()
    }
    
    @IBAction func scheduleClicked(_ sender: Any) {
        transitionToViewController(id: "Schedule")
    }
    
    @IBAction func feedClicked(_ sender: Any) {
        transitionToViewController(id: "Feed")
    }
    
    @IBAction func mapClicked(_ sender: Any) {
        transitionToViewController(id: "Map")
    }
    
    @IBAction func huntClicked(_ sender: Any) {
        transitionToViewController(id: "Hunt")
    }
}
