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
    
    var mapBoundary: MGLCoordinateBounds!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
    }
    
    override func viewDidLayoutSubviews() {
        mapView.roundTopTwoCorners()
    }
    
    @IBAction func menuButtonClicked(_ sender: Any) {
        sideMenuController?.revealMenu()
    }
    
    func setupMapView() {
        // set style
        mapView.styleURL = URL(string: "mapbox://styles/anshaysaboo/ck3pe1pwq0oiv1cqedywbygl3")
        
        // delegate
        mapView.delegate = self
        
        // zoom in on University High School
        let uniCoords = CLLocationCoordinate2D(latitude: 33.651785, longitude: -117.822857)
        mapView.setCenter(uniCoords, zoomLevel: 16, animated: false)
        
        // set boundaries
        let northeast = CLLocationCoordinate2D(latitude: 33.657009, longitude: -117.816946)
        let southwest = CLLocationCoordinate2D(latitude: 33.645963, longitude: -117.829540)
        mapBoundary = MGLCoordinateBounds(sw: southwest, ne: northeast)
        
        // show user location
        mapView.showsUserLocation = true
        mapView.showsHeading = true
        
        // tap gesture recognizer
        let recog = UITapGestureRecognizer(target: self, action: #selector(mapViewWasSelected(_:)))
        mapView.addGestureRecognizer(recog)
        
        // add the locker block annotations to the view
        let lockerNames = MapManager().buildingNames
        let lockerCoordinates = MapManager().buildingCoordinates
        for i in 0...lockerNames.count-1 {
            let annotation = MGLPointAnnotation()
            annotation.coordinate = lockerCoordinates[i]
            annotation.title = lockerNames[i]
            //mapView.addAnnotation(annotation)
        }
    }
}
    
// MARK:- MapView Delegate
extension MapViewController: MGLMapViewDelegate {
    
    /*
     // This example uses Colorado’s boundaries to restrict the camera movement.
    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool {
         
        // Get the current camera to restore it after.
        let currentCamera = mapView.camera
        // From the new camera obtain the center to test if it’s inside the boundaries.
        let newCameraCenter = newCamera.centerCoordinate
        // Set the map’s visible bounds to newCamera.
        mapView.camera = newCamera
        let newVisibleCoordinates = mapView.visibleCoordinateBounds
        // Revert the camera.
        mapView.camera = currentCamera
        // Test if the newCameraCenter and newVisibleCoordinates are inside self.colorado.
        let inside = MGLCoordinateInCoordinateBounds(newCameraCenter, self.mapBoundary)
        let intersects = MGLCoordinateInCoordinateBounds(newVisibleCoordinates.ne, self.self.mapBoundary) && MGLCoordinateInCoordinateBounds(newVisibleCoordinates.sw, self.self.mapBoundary)
         
        return inside && intersects
    }*/
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        let reuseIdentifier = annotation.title!
        let annotationView = LabelAnnotationView(reuseIdentifier: reuseIdentifier)
        annotationView.title = annotation.title!!
        return nil
    }
    
    @objc func mapViewWasSelected(_ sender: UIGestureRecognizer!) {
        let tapPoint: CGPoint = sender.location(in: mapView)
        let tapCoordinate: CLLocationCoordinate2D = mapView.convert(tapPoint, toCoordinateFrom: nil)
        print(tapCoordinate)
    }

}

class LabelAnnotationView: MGLAnnotationView {
    
    private var titleLabel: UILabel!
    public var title = ""
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setup()
    }
    
    func setup() {
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        titleLabel.text = title
        self.addSubview(titleLabel)
    }
}
