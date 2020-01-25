//
//  Cells.swift
//  Convenio
//
//  Created by Anshay Saboo on 10/20/19.
//  Copyright © 2019 Anshay Saboo. All rights reserved.
//

import Foundation
import UIKit

// MARK:- EventCell
class EventCell: UITableViewCell {
    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func setup(event: Event, row: Int) {
        
        // fill out the cell information
        self.titleLabel.text = event.title
        let room = event.room
        let (startTime, endTime) = event.getTimesFormatted()
        subtitleLabel.attributedText = formatSubtitle(time: "\(startTime) - \(endTime)", room: room)
        typeLabel.text = event.type.uppercased()
        self.clipsToBounds = false
        self.contentView.clipsToBounds = false
        self.layer.zPosition = CGFloat(500 - row)
    }
    
    // format the subtitle label's attributed string
    private func formatSubtitle(time: String, room: String) -> NSMutableAttributedString {
        let boldFontAttr = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 15.0)!]
        let regularFontAttr =  [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Regular", size: 15.0)!]
        let heavyFontAttr =  [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Heavy", size: 15.0)!]
        
        let timeText = NSMutableAttributedString(string: time, attributes: boldFontAttr)
        let roomText = NSMutableAttributedString(string: room, attributes: regularFontAttr)
        let separator = NSMutableAttributedString(string: " · ", attributes: heavyFontAttr)
        
        timeText.append(separator)
        timeText.append(roomText)
        
        return timeText
    }
 
}

// MARK:- EventCell
class TimeDividerCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    
}

// MARK:- EventCell
class FeedEventCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var timeIndicatorView: UIImageView!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    
    func setup(event: Event) {
        titleLabel.text = event.title
    }
    
    
}

// MARK:- EventCell
class FeedLongEventCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var roomLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var timeIndicatorView: UIImageView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var detailsHeightConstraint: NSLayoutConstraint!
    
    func setup(event: Event) {
        titleLabel.text = event.title
        detailsLabel.text = event.description
    }
}

// MARK:- EventCell
class FeedAnnouncementCell: UITableViewCell {
    
}
