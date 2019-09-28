//
//  MapViewController.swift
//  WildCharity
//
//  Created by Egor on 27/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import SceneKit
import ARKit

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, ARSCNViewDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var changeViewButton: UIButton!
    
    var locationManager: CLLocationManager?
    var userPositionMarker: GMSMarker!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 12.0)
        
        mapView.camera = camera
        mapView.delegate = self
        
        userPositionMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        userPositionMarker.map = mapView
        
        mapView.camera = GMSCameraPosition.camera(withTarget: locationManager?.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), zoom: 12.0)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        locationManager?.startUpdatingLocation()
        setupMap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        locationManager?.stopUpdatingLocation()
        mapView.clear()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        changeViewButton.layer.cornerRadius = 10
    }
    
    
    @IBAction func changeViewButtonTapped(_ sender: UIButton) {
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            guard let latitude = locations.last?.coordinate.latitude else { return }
            guard let longitude = locations.last?.coordinate.longitude else { return }
            
            userPositionMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error!: \(error)")
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
