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
    
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    
    var options: [MenuOption] = []

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
        
        // tableview setup
        menuTableView.isScrollEnabled = false
        menuTableView.separatorStyle = .none
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        options = SideMenuOptions.options
        
        // load up all view controllers
        for option: MenuOption in options {
            if option.id.isEmpty { continue }
            sideMenuController?.cache(viewControllerGenerator: {
                self.storyboard?.instantiateViewController(withIdentifier: option.id)
            }, with: option.name)
        }
        
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
}

// MARK:- Table View Delegate
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentOptionName = options[indexPath.row].name
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 20)
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = currentOptionName
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        
        sideMenuController?.hideMenu(animated: true, completion: nil)
        self.sideMenuController?.setContentViewController(with: self.options[indexPath.row].name, animated: true)
    }
}

// MARK:- Helper Classes

/// The options to show in the menu
struct SideMenuOptions {
    public static let options: [MenuOption] = [
        MenuOption(name: "Feed", id: "FeedViewController"),
        MenuOption(name: "Schedule", id: "ScheduleViewController"),
        MenuOption(name: "Map", id: "MapViewController"),
        MenuOption(name: "Scavenger Hunt", id: "HuntMainViewController")
    ]
    
}


/// Represents an option in the menu
class MenuOption {
    var name = ""
    var id = ""
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
}
