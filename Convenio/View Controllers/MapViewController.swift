//
//  MapViewController.swift
//  Convenio
//
//  Created by Anshay Saboo on 11/30/19.
//  Copyright © 2019 Anshay Saboo. All rights reserved.
//

import UIKit
import Mapbox
import SideMenuSwift

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var mapBoundary: MGLCoordinateBounds!
    
    var eventsToDisplay: [Event] = []
    var locations: [Location] = []
    
    var selectedEvent: Event!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // begin setting up the view
        setupMapView()
        
        // display the indicator
        activityIndicator.startAnimating()
    }
    
    override func viewDidLayoutSubviews() {
        mapView.roundTopTwoCorners()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowEventDetails" {
            let dest: EventDetailsViewController = segue.destination as! EventDetailsViewController
            dest.eventToShow = selectedEvent
        }
    }
    
    // Fetch the geo dataset with coordinates of all points
    func setupAnnotations() {
        setupEvents()
        MapManager.getAllUniGeoPoints { (locations, success) in
            // hide activity indicator
            self.activityIndicator.isHidden = true
            // display annotations
            self.locations = locations
            self.addEventAnnotations()
        }
    }
    
    func setupMapView() {
        // delegate
        mapView.delegate = self
        
        // zoom in on University High School
        let uniCoords = CLLocationCoordinate2D(latitude: 33.651785, longitude: -117.822857)
        mapView.setCenter(uniCoords, zoomLevel: 17, animated: false)
        
        // set boundaries
        let northeast = CLLocationCoordinate2D(latitude: 33.657009, longitude: -117.816946)
        let southwest = CLLocationCoordinate2D(latitude: 33.645963, longitude: -117.829540)
        mapBoundary = MGLCoordinateBounds(sw: southwest, ne: northeast)
        
        // show user location
        mapView.showsUserLocation = true
        mapView.showsHeading = true
        
    }
    
    // Populate the event array with demo events
    func setupEvents() {
        setupMapView()
        let startDate = "4:30 PM".toDate(withFormat: "h:mm a")
        let endDate = "5:30 PM".toDate(withFormat: "h:mm a")
        let event = Event(title: "Cookie Decorating", startTime: startDate, endTime: endDate, room: "509B", type: "ACTIVITY")
        eventsToDisplay.append(event)
        
        let event2 = Event(title: "Open Certamen", startTime: startDate, endTime: endDate, room: "210", type: "ACADEMIC")
        eventsToDisplay.append(event2)
        
        let event3 = Event(title: "That's Entertainment!", startTime: startDate, endTime: endDate, room: "Theater", type: "ACTIVITY")
        eventsToDisplay.append(event3)
        
        let event4 = Event(title: "Latin Oratory", startTime: startDate, endTime: endDate, room: "316", type: "ACADEMIC")
        eventsToDisplay.append(event4)
    }
    
    func addEventAnnotations() {
        // loop through the events and add each one to the view
        for ev: Event in eventsToDisplay {
            // create an annotation for each
            let anno = MGLPointAnnotation()
            // get the coordinates of the location specified
            anno.coordinate = MapManager.getCoordinatesOfRoom(room: ev.room, locations: locations)
            anno.title = ev.title
            anno.subtitle = ev.getLocationFormatted()
            mapView.addAnnotation(anno)
        }
    }
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
}
    
// MARK:- MapView Delegate
extension MapViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        let annoImage = UIImage(cgImage: (UIImage(named: "MapAnnotation")?.cgImage)!, scale: 6, orientation: .up)
        return MGLAnnotationImage(image: annoImage, reuseIdentifier: "image")
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        setupAnnotations()
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        // transfer to the details screen
        mapView.deselectAnnotation(annotation, animated: true)
        // get the event that was selected
        selectedEvent = eventsToDisplay.first(where: { (ev) -> Bool in
            return ev.title == annotation.title
        })
        performSegue(withIdentifier: "ShowEventDetails", sender: self)
    }

}
