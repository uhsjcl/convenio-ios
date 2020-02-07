//
//  HuntMainViewController.swift
//  Convenio
//
//  Created by Anshay Saboo on 12/9/19.
//  Copyright © 2019 Anshay Saboo. All rights reserved.
//

import UIKit
import AnimatedGradientView
import SideMenuSwift

class HuntMainViewController: UIViewController {
    
    @IBOutlet var backgroundView: LavaBackgroundView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        backgroundView.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundView.startAnimating()
    }
    
    /// Add and begin animating the background
    func startAnimatingBackground() {
        
    }
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
}
