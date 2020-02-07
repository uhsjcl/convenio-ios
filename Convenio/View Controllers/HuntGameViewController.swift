//
//  HuntGameViewController.swift
//  Convenio
//
//  Created by Anshay Saboo on 2/6/20.
//  Copyright © 2020 Anshay Saboo. All rights reserved.
//

import UIKit

class HuntGameViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: LavaBackgroundView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        backgroundView.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        backgroundView.startAnimating()
    }
}
