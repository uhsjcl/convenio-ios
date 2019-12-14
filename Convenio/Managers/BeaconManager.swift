//
//  BeaconManager.swift
//  Convenio
//
//  Created by Anshay Saboo on 10/23/19.
//  Copyright © 2019 Anshay Saboo. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconManager {
    
    var locationManager: CLLocationManager!
    
    init() {
        locationManager = CLLocationManager()
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")

        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
}
