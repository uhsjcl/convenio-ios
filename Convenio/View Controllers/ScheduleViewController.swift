//
//  ScheduleViewController.swift
//  Convenio
//
//  Created by Anshay Saboo on 10/20/19.
//  Copyright © 2019 Anshay Saboo. All rights reserved.
//

import UIKit
import AVFoundation
import SideMenuSwift
import BetterSegmentedControl

class ScheduleViewController: UIViewController {

    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var dayPicker: BetterSegmentedControl!
    @IBOutlet weak var tableBackground: UIView!
    @IBOutlet weak var toggleFavoritesButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var eventsToShow: [Event] = []
    var cells: [ScheduleCell] = []
    
    var fridayCells: [ScheduleCell] = []
    var fridayEvents: [Event] = []
    var saturdayCells: [ScheduleCell] = []
    var saturdayEvents: [Event] = []
    
    var selectedEvent: Event!
    var rowsAnimated: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // events table delegate and data source
        eventsTable.delegate = self
        eventsTable.dataSource = self
        // style the table
        eventsTable.separatorStyle = .none
        eventsTable.estimatedRowHeight = 110
        eventsTable.rowHeight = UITableView.automaticDimension
        
        setupUI()
        setupEvents()
        
        // Tab bar styling
        guard let tabBar = self.tabBarController?.tabBar else { return }
        tabBar.barTintColor = UIColor.white
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEventDetails" {
            let dest: EventDetailsViewController = segue.destination as! EventDetailsViewController
            dest.eventToShow = selectedEvent
        }
    }
    
    func setupUI() {
        // style the segmented control
        dayPicker.segments = LabelSegment.segments(withTitles: ["Friday","Saturday"], numberOfLines: 0, normalFont: UIFont(name: "AvenirNext-DemiBold", size: 16), normalTextColor: UIColor.white.withAlphaComponent(0.65), selectedBackgroundColor: .clear, selectedFont:UIFont(name: "AvenirNext-DemiBold", size: 16), selectedTextColor: UIColor.white)
        dayPicker.indicatorViewBackgroundColor = UIColor.white.withAlphaComponent(0.4)
    }
    
    func setupEvents() {
        // Dummy event data
        self.fridayEvents.append(Event(title: "Cookie Decorating", startTime: "5:30 PM".toDate(withFormat: "h:mm a"), endTime: "7:00 PM".toDate(withFormat: "h:mm a"), room: "504", type: "ACTIVITY"))
        self.fridayEvents.append(Event(title: "Escape Room", startTime: "7:30 PM".toDate(withFormat: "h:mm a"), endTime: "10:00 PM".toDate(withFormat: "h:mm a"), room: "312", type: "ACTIVITY"))
        self.fridayEvents.append(Event(title: "Chess Tournament", startTime: "5:30 PM".toDate(withFormat: "h:mm a"), endTime: "7:30 PM".toDate(withFormat: "h:mm a"), room: "504", type: "SPORTS"))
        self.fridayEvents.append(Event(title: "Open Certamen", startTime: "6:30 PM".toDate(withFormat: "h:mm a"), endTime: "9:00 PM".toDate(withFormat: "h:mm a"), room: "504", type: "ACADEMIC"))
        self.fridayEvents.append(Event(title: "Ping Pong Tournament", startTime: "6:30 PM".toDate(withFormat: "h:mm a"), endTime: "9:00 PM".toDate(withFormat: "h:mm a"), room: "222", type: "SPORTS"))
        self.fridayEvents.append(Event(title: "Dodgeball", startTime: "5:30 PM".toDate(withFormat: "h:mm a"), endTime: "7:00 PM".toDate(withFormat: "h:mm a"), room: "Blacktop", type: "ACTIVITY"))
        self.fridayEvents.append(Event(title: "Dinner", startTime: "7:30 PM".toDate(withFormat: "h:mm a"), endTime: "9:00 PM".toDate(withFormat: "h:mm a"), room: "Crossroads", type: "ACTIVITY"))
        
        self.saturdayEvents.append(Event(title: "Chariot Race", startTime: "12:30 PM".toDate(withFormat: "h:mm a"), endTime: "2:00 PM".toDate(withFormat: "h:mm a"), room: "Field", type: "ACTIVITY"))
        self.saturdayEvents.append(Event(title: "Myth Jenga", startTime: "1:30 PM".toDate(withFormat: "h:mm a"), endTime: "3:00 PM".toDate(withFormat: "h:mm a"), room: "312", type: "ACTIVITY"))
        self.saturdayEvents.append(Event(title: "Costume Contest", startTime: "1:30 PM".toDate(withFormat: "h:mm a"), endTime: "3:30 PM".toDate(withFormat: "h:mm a"), room: "504", type: "ARTS"))
        self.saturdayEvents.append(Event(title: "Roman Rap Battle", startTime: "3:30 PM".toDate(withFormat: "h:mm a"), endTime: "5:00 PM".toDate(withFormat: "h:mm a"), room: "504", type: "ACTIVITY"))
        self.saturdayEvents.append(Event(title: "English Oratory", startTime: "3:30 PM".toDate(withFormat: "h:mm a"), endTime: "5:00 PM".toDate(withFormat: "h:mm a"), room: "321", type: "ACADEMICS"))
        self.saturdayEvents.append(Event(title: "Escape Room", startTime: "4:30 PM".toDate(withFormat: "h:mm a"), endTime: "6:00 PM".toDate(withFormat: "h:mm a"), room: "Blacktop", type: "ACTIVITY"))
        self.saturdayEvents.append(Event(title: "Archery", startTime: "3:30 PM".toDate(withFormat: "h:mm a"), endTime: "5:00 PM".toDate(withFormat: "h:mm a"), room: "Crossroads", type: "ACTIVITY"))
        
        self.fridayCells = getCellsFromEvents(events: fridayEvents)
        self.saturdayCells = getCellsFromEvents(events: saturdayEvents)
    
        self.cells = fridayCells
        
        
    }
    
    func changeTitleText(text: String) {
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.alpha = 0
        }) { (_) in
            self.titleLabel.text = text
            UIView.animate(withDuration: 0.3, animations: {
                self.titleLabel.alpha = 1
            })
        }
    }
    
    func getCellsFromEvents(events: [Event]) -> [ScheduleCell] {
        var cells: [ScheduleCell] = []
        // get all the start times, and then sort them
        var startTimes: [Date] = []
        for event: Event in events {
            if !startTimes.contains(event.startTime) {
                startTimes.append(event.startTime)
            }
        }
        startTimes.sort { (date1, date2) -> Bool in
            return date1 < date2
        }
        
        // go through start times and get them all
        for time: Date in startTimes {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "h:mm a"
            let timeString = formatter.string(from: time)
            
            let eventsForTime = events.filter { (event) -> Bool in
                return formatter.string(from: event.startTime) == timeString
            }
            
            let eventCells = eventsForTime.map { (event) -> ScheduleCell in
                return ScheduleCell(type: .event, event: event)
            }
            
            let timeCell = ScheduleCell(type: .time, time: timeString)
            
            cells.append(timeCell)
            cells.append(contentsOf: eventCells)
        }
        return cells
    }
    
    override func viewDidLayoutSubviews() {
        tableBackground.roundTopTwoCorners()
    }
    
    @IBAction func showMenuClicked(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    @IBAction func switchDays(_ sender: Any) {
        rowsAnimated.removeAll()
        var newText = ""
        if dayPicker.index == 0 {
            // show Friday's events
            cells = fridayCells
            newText = "April 17th"
            eventsTable.reloadData()
        } else {
            // show Saturday's events
            cells = saturdayCells
            newText = "April 18th"
            eventsTable.reloadData()
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.titleLabel.alpha = 0
        }) { (_) in
            self.titleLabel.text = newText
            UIView.animate(withDuration: 0.2, animations: {
                self.titleLabel.alpha = 1
            }) { (_) in
                self.titleLabel.alpha = 1
            }
        }
    }
}

// MARK:- TableView Delegate and Data Source
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == cells.count {
            // add bottom padding
            let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: 400, height: 500))
            cell.backgroundColor = .clear
            cell.contentView.backgroundColor = .clear
            return cell
        }
        
        let scheduleCell = cells[indexPath.row]
        
        if scheduleCell.type == .event {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
            cell.setup(event: scheduleCell.event, row: indexPath.row)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TimeDividerCell", for: indexPath) as! TimeDividerCell
            cell.timeLabel.text = scheduleCell.time
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellSelected = cells[indexPath.row]
        if cellSelected.type != .event {
            return
        }
        UIImpactFeedbackGenerator().impactOccurred()
        self.selectedEvent = cellSelected.event
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ShowEventDetails", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if rowsAnimated.contains(indexPath.row) {
            return
        }
        cell.transform = CGAffineTransform(translationX: 0, y: cell.frame.height / 2)
        cell.alpha = 0
        rowsAnimated.append(indexPath.row)
        UIView.animate(
            withDuration: 0.35,
            delay: indexPath.row < 9 ? 0.1*Double(indexPath.row) : 0.05,
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
        })
    }
    
}

class ScheduleCell {
    var type: ScheduleCellType!
    var event: Event!
    var time = ""
    
    init(type: ScheduleCellType, event: Event) {
        self.type = type
        self.event = event
    }
    
    init(type: ScheduleCellType, time: String) {
        self.type = type
        self.time = time
    }
}

enum ScheduleCellType {
    case time
    case event
}
