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
    
    var favoriteEvents: [Event] = []
    var player: AVAudioPlayer!
    var eventCells: [ScheduleCell] = []
    var favoriteCells: [ScheduleCell] = []
    var times: [String] = []
    var selectedEvent: Event!
    var isShowingFavorites = false
    var rowsAnimated: [Int] = []
    var activityIndicator: UIActivityIndicatorView!
    var cheatCounter = 0
    
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
    
    func setupUI() {
        // show an activity indicator
        //addActivityIndicator()
        // style the segmented control
        dayPicker.segments = LabelSegment.segments(withTitles: ["Friday","Saturday"], numberOfLines: 0, normalFont: UIFont(name: "AvenirNext-DemiBold", size: 16), normalTextColor: UIColor.white.withAlphaComponent(0.65), selectedBackgroundColor: .clear, selectedFont:UIFont(name: "AvenirNext-DemiBold", size: 16), selectedTextColor: UIColor.white)
        //dayPicker.indicatorViewBorderColor = UIColor.white.withAlphaComponent(0.85)
        //dayPicker.indicatorViewBorderWidth = 2.0
        dayPicker.indicatorViewBackgroundColor = UIColor.white.withAlphaComponent(0.4)
    
    }
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.color = UIColor.darkGray
        activityIndicator.center = CGPoint(x: self.tableBackground.bounds.size.width / 2, y: 50)
        tableBackground.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func setupEvents() {
        // Dummy event data
        let event = Event()
        event.title = "Open Certamen"
        event.type = "ACADEMIC"
        event.room = "Room 713"
        event.startTime = Date()
        event.endTime = Date().addingTimeInterval(3600)
        for _ in 0...2 {
            self.fridayEvents.append(event)
        }
        let event2 = Event()
        event2.title = "Roman Poetry by Ovid, Martial, and Catullus"
        event2.type = "WORKSHOP"
        event2.room = "Room 511"
        event2.startTime = Date().addingTimeInterval(7200)
        event2.endTime = Date().addingTimeInterval(3600 * 3)
        for _ in 0...1 {
            self.fridayEvents.append(event2)
            self.saturdayEvents.append(event2)
        }
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        if isShowingFavorites {
            favoriteEvents = DataManager.getFavoriteEvents()
            favoriteCells = getCellsFromEvents(events: favoriteEvents)
            cells = favoriteCells
            eventsTable.reloadData()
        }
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
    
    @IBAction func toggleShowingFavorites(_ sender: Any) {
        
        UIImpactFeedbackGenerator().impactOccurred()
        
        eventsTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        cells = []
        eventsTable.reloadData()
        
        rowsAnimated.removeAll()
        
        if isShowingFavorites {
            changeTitleText(text: "Schedule")
            toggleFavoritesButton.setImage(UIImage(named: "WhiteHeartEmpty"), for: .normal)
            cells = eventCells
        } else {
            changeTitleText(text: "My Events")
            toggleFavoritesButton.setImage(UIImage(named: "WhiteHeartFilled"), for: .normal)
            favoriteEvents = DataManager.getFavoriteEvents()
            favoriteCells = getCellsFromEvents(events: favoriteEvents)
            cells = favoriteCells
        }
        
        eventsTable.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.eventsTable.reloadData()
        }
        
        
        isShowingFavorites = !isShowingFavorites
    }
}

// MARK:- TableView Delegate and Data Source
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
        
        
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
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellSelected = cells[indexPath.row]
        if cellSelected.type != .event {
            return
        }
        if cellSelected.event.description.isEmpty {
            return
        }
        UIImpactFeedbackGenerator().impactOccurred()
        self.selectedEvent = cellSelected.event
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "eventInfoSegue", sender: self)
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
