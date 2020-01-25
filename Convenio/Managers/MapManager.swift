//
//  MapManager.swift
//  Convenio
//
//  Created by Anshay Saboo on 12/1/19.
//  Copyright © 2019 Anshay Saboo. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON
import Alamofire

// handles all map-related functions, storing the coordinates of rooms and buildings
class MapManager {
    
    /// Returns a JSON array of all GeoPoints marked on the map
    static func getAllUniGeoPoints(completion: @escaping ([Location], Bool) -> Void) {
        let url = "https://api.mapbox.com/datasets/v1/anshaysaboo/ck3ouwha11sfq2io1zbbw2859/features?limit=100&access_token=pk.eyJ1IjoiYW5zaGF5c2Fib28iLCJhIjoiY2lyY2I5OXFpMDE4MWdkbmtqMzBueTdmayJ9.IhsuK6OY1qmXPj4PkJI-yw"
        // TODO: Actually fetch all features
        Alamofire.request(url, method: .get).responseJSON { response in
            
            // TODO: Handle error
            
            // convert response into JSON
            let json = try! JSON(data: response.data!)
            let featuresArray = json["features"].array!
            var points: [Location] = []
            // convert all geopoints into locations
            for j: JSON in featuresArray {
                let type = String(describing: j["geometry"]["type"].string!)
                if type == "Point" {
                    let loc = Location(json: j)
                    points.append(loc)
                }
            }
            completion(points, true)
        }
    }
    
    // Returns the Lat/Long of the given room code
    static func getCoordinatesOfRoom(room: String, locations: [Location]) -> CLLocationCoordinate2D {
        var pickedLocation: Location!
        for loc: Location in locations {
            if loc.roomCode == room {
                pickedLocation = loc
                break
            }
        }
        return pickedLocation!.coordinates
    }
    
}

