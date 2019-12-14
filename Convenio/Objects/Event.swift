//
//  Event.swift
//  Convenio
//
//  Created by Anshay Saboo on 10/20/19.
//  Copyright © 2019 Anshay Saboo. All rights reserved.
//

import Foundation
import SwiftyJSON


// represents a single event
class Event {
    var title = ""
    var description = ""
    var startTime: Date!
    var endTime: Date!
    var room = ""
    var type = ""
    
    init() {}
    
    init(json: JSON) {
        self.title = String(describing: json["title"].string)
        self.description = String(describing: json["description"].string)
        self.room = String(describing: json["room"].string)
        self.type = String(describing: json["type"].string)
        self.startTime = Date(timeIntervalSince1970: json["startTime"] as! TimeInterval)
        self.endTime = Date(timeIntervalSince1970: json["endTime"] as! TimeInterval)
    }
    
    init(data: Data) {
        let dataDict = NSKeyedUnarchiver.unarchiveObject(with: data) as! [String:Any]
        self.title = String(describing: dataDict["title"]!)
        self.description = String(describing: dataDict["description"]!)
        self.room = String(describing: dataDict["room"]!)
        self.type = String(describing: dataDict["type"]!)
        self.startTime = Date(timeIntervalSince1970: dataDict["startTime"] as! TimeInterval)
        self.endTime = Date(timeIntervalSince1970: dataDict["endTime"] as! TimeInterval)
    }
    
    func getTimesFormatted() -> (String, String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let startString = formatter.string(from: startTime)
        let endString = formatter.string(from: endTime)
        return (startString, endString)
    }
    
    func storable() -> Data {
        let dataDict: [String:Any] = [
            "title":title,
            "description":description,
            "startTime":startTime.timeIntervalSince1970,
            "endTime":endTime.timeIntervalSince1970,
            "room":room,
            "type":type
        ]
        let data = NSKeyedArchiver.archivedData(withRootObject: dataDict)
        return data
    }
    
}
