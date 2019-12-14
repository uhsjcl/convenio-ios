//
//  MapManager.swift
//  Convenio
//
//  Created by Anshay Saboo on 12/1/19.
//  Copyright © 2019 Anshay Saboo. All rights reserved.
//

import Foundation
import CoreLocation

// handles all map-related functions, storing the coordinates of rooms and buildings
class MapManager {
    var bathroomCoordinates: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 33.65335682502625, longitude: -117.82213816799168),
        CLLocationCoordinate2D(latitude: 33.65217237822861, longitude: -117.82293617748056),
        CLLocationCoordinate2D(latitude: 33.65240406313285, longitude: -117.82149561304396)
    ]
    
    var buildingNames: [String] = [
        "200",
        "300",
        "400",
        "500",
        "700",
        "900/1000"/*,
        "Theater",
        "Office",
        "Small Gym",
        "Main Gym"*/
    ]
    var buildingCoordinates: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 33.651326, longitude: -117.822672),
        CLLocationCoordinate2D(latitude: 33.651581, longitude: -117.821850),
        CLLocationCoordinate2D(latitude: 33.652214, longitude: -117.821564),
        CLLocationCoordinate2D(latitude: 33.652371, longitude: -117.822585),
        CLLocationCoordinate2D(latitude: 33.651693, longitude: -117.822855),
        CLLocationCoordinate2D(latitude: 33.652822, longitude: -117.821818)
    ]
}
