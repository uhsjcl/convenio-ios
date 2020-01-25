//
//  EventDetailsViewController.swift
//  Convenio
//
//  Created by Anshay Saboo on 1/24/20.
//  Copyright © 2020 Anshay Saboo. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var detailsLabel: UITextView!
    
    var eventToShow: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fill out all fields
        titleLabel.text = eventToShow.title
        typeLabel.text = eventToShow.type
        let (startTime, endTime) = eventToShow.getTimesFormatted()
        timeLabel.text = "\(startTime) - \(endTime)"
        roomLabel.text = eventToShow.getLocationFormatted()
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
