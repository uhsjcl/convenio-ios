//
//  GeoPoint.swift
//  Convenio
//
//  Created by Anshay Saboo on 1/24/20.
//  Copyright © 2020 Anshay Saboo. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

/// Represents a location on campus where an activity can happen
class Location {
    var roomCode = ""
    var coordinates: CLLocationCoordinate2D!
    
    init(json: JSON) {
        // TODO: Ensure this doesn't fail
        roomCode = String(describing: json["properties"]["name"])
        let lat = json["geometry"]["coordinates"][1].double!
        let long = json["geometry"]["coordinates"][0].double!
        coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
