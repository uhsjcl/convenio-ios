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

    override func viewDidLoad() {
        super.viewDidLoad()
        startAnimatingBackground()
    }
    
    func startAnimatingBackground() {
        let gradient = AnimatedGradientView(frame: view.bounds)
        var gradients: [AnimatedGradientView.AnimationValue] = []

        let directions: [AnimatedGradientView.Direction] = [.up,.down,.downRight,.downRight,.upLeft,.upRight,.right,.left]
        let allColors: [String] = ["#ff0000","#ff7300","#ffb700","#ff0000"]
        for _ in 0...6 {
            var colors: [String] = []
            for _ in 0...1 {
                colors.append(allColors.randomElement()!)
            }
            let direction = directions.randomElement()!
            let animValue = AnimatedGradientView.AnimationValue(colors: colors, direction, .axial)
            gradients.append(animValue)
        }
        gradient.animationValues = gradients
        gradient.animationDuration = 1
        view.insertSubview(gradient, at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
}
