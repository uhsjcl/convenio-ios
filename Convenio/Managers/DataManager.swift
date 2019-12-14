//
//  DataManager.swift
//  Convenio
//
//  Created by Anshay Saboo on 10/20/19.
//  Copyright © 2019 Anshay Saboo. All rights reserved.
//

import Foundation
import NotificationCenter
import UserNotifications
import Alamofire

// handles fetching and storage of data
class DataManager {
    
    let GET_EVENTS_URL = ""
    
    // MARK:- Data fetching
    func getAllEvents(completion: ([Event], Bool) -> Void) {
        Alamofire.request(GET_EVENTS_URL, method: .get).responseJSON { (repsonse) in
            
        }
    }
    
    
    // MARK:- Local Datastore related methods
    
    /// Get the speakers from the data store

    /// Get the events from the data store
    static func getEventsFromDatastore() -> [Event] {
        let data = UserDefaults.standard.object(forKey: "eventData") as! [Data]
        var events: [Event] = []
        for d: Data in data {
            let event = Event(data: d)
            events.append(event)
        }
        return events
    }
    
    // MARK:- Favorite events methods
    
    /// Add an event to the user's "My Events"
    static func addEventToFavorites(event: Event) {
        createNotificationForEvent(event: event)
        if let _ = UserDefaults.standard.object(forKey: "favoriteEvents") {
            var favEventNames = UserDefaults.standard.object(forKey: "favoriteEvents") as! [String]
            favEventNames.append(event.title)
            favEventNames.removeDuplicates()
            UserDefaults.standard.set(favEventNames, forKey: "favoriteEvents")
        } else {
            UserDefaults.standard.set([event.title], forKey: "favoriteEvents")
        }
    }
    
    /// Remove an event from "My Events"
    static func removeEventFromFavorites(event: Event) {
        removeNotificationForEvent(event: event)
        if let _ = UserDefaults.standard.object(forKey: "favoriteEvents") {
            var favEventNames = UserDefaults.standard.object(forKey: "favoriteEvents") as! [String]
            favEventNames.removeAll { (name) -> Bool in
                return name == event.title
            }
            UserDefaults.standard.set(favEventNames, forKey: "favoriteEvents")
        }
    }
    
    /// Get the "My Events" list
    static func getFavoriteEvents() -> [Event] {
        if let _ = UserDefaults.standard.object(forKey: "favoriteEvents") {
            let favEventNames = UserDefaults.standard.object(forKey: "favoriteEvents") as! [String]
            let allEvents = getEventsFromDatastore()
            var favEvents: [Event] = []
            for event: Event in allEvents {
                if favEventNames.contains(event.title) {
                    favEvents.append(event)
                }
            }
            return favEvents
        } else {
            UserDefaults.standard.set([], forKey: "favoriteEvents")
            return []
        }
    }
    
    /// Check if the event is a favorite event
    static func isEventFavorite(event: Event) -> Bool {
        let favEvents = getFavoriteEvents()
        var doesExist = false
        for e: Event in favEvents {
            if e.title == event.title {
                doesExist = true
            }
        }
        return doesExist
    }
    
    // MARK:- Notification scheduling methods
    
    /// Schedule a notification for the given event
    static func createNotificationForEvent(event: Event) {
        
        let content = UNMutableNotificationContent()
        content.title = "Event starting soon!"
        content.body = event.title
        content.subtitle = "Starting at \(event.getTimesFormatted().0) in \(event.room)"
        content.sound = .default
        content.badge = 1
        
        
        let tenMinutesBefore = Calendar.current.date(byAdding: .minute, value: -10, to: event.startTime, wrappingComponents: false)
        // create the date trigger for the favorited event
        var comp = Calendar.current.dateComponents([.day,.month,.year,.hour,.minute], from: tenMinutesBefore!)
        comp.setValue(9, for: .month)
        comp.setValue(2019, for: .year)
        comp.setValue(29, for: .day)
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: comp, repeats: false)
        let request = UNNotificationRequest(identifier: event.title, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            } else  {
                print("Sucessful scheduling!")
            }
        }
    }
    
    /// Remove the scheduled notification for the given event
    static func removeNotificationForEvent(event: Event) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [event.title])
    }
    
    // MARK:- Error method
    static func showErrorMessage(vc: UIViewController) {
        let alert = UIAlertController(title: "Oops!", message: "Something went wrong. Please check your network connection and try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
}
