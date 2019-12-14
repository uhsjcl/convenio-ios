//
//  CardView.swift
//  Convenio
//
//  Created by Anshay Saboo on 10/20/19.
//  Copyright © 2019 Anshay Saboo. All rights reserved.
//

import Foundation
import UIKit

/// UIView subclass that draws a view with rounded corners, and drop shadow
class CardView: UIView {
    
    override init(frame: CGRect)  {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        //  add shadow backdrop to view, and round corners
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.cornerRadius = 15
    }
}

/// UIView subclass that creates the green gradient header views
class HeaderView: UIView {
    override init(frame: CGRect)  {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(rgb:0x2ecc71).cgColor,
            UIColor(rgb: 0x27ae60).cgColor
        ]
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
}

/// UITextField subclass that adds a custom padding to the text field
class PaddingTextField: UITextField {
    
    var leftPadding: CGFloat! = 15.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
