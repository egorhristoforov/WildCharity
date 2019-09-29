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

class MapViewController: UIViewController, GMSMapViewDelegate, ARSCNViewDelegate {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var changeViewButton: UIButton!
    
    private var locationManager: CLLocationManager?
    private var userPositionMarker: GMSMarker!
    private var wildPoints: [WildPoint] = []
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 0, longitude: 0, zoom: 12.0)
        
        mapView.camera = camera
        mapView.delegate = self
        
        userPositionMarker = GMSMarker(position: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        userPositionMarker.map = mapView
        
        mapView.camera = GMSCameraPosition.camera(withTarget: locationManager?.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), zoom: 12.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        downloadData()
        setupMap()
        locationManager?.startUpdatingLocation()
        
    }
    
    private func downloadData() {
        if Reachability.isConnectedToNetwork() {
        
            DataLoader().getWildPoints { (responseWildPoints) in
                self.wildPoints = responseWildPoints.wildpoints
                print("Success")
                self.addMarkers()
            }
            
        } else {
            let alert = UIAlertController(title: "Упс", message: "Отсутствует подключение к интернету", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Закрыть", style: .default){ action in
                self.viewDidLoad()
            })

            self.present(alert, animated: true)
        }
    }
    
    private func addMarkers() {
        for point in wildPoints {
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: point.lat, longitude: point.lon))
            marker.icon = UIImage(named: "WildPointMarker")
            marker.setIconSize(scaledToSize: .init(width: 32, height: 32))
            marker.map = mapView
        }
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
        
        setupUI()
    }
    
    private func setupUI() {
        changeViewButton.layer.cornerRadius = 10
    }

    @IBAction func changeViewButtonTapped(_ sender: Any) {
        locationManager?.startUpdatingLocation()
        guard let latitude = locationManager?.location?.coordinate.latitude else { return }
        guard let longitude = locationManager?.location?.coordinate.longitude else { return }
        let request = RequestNearbyWildPoints(lon: longitude, lat: latitude)
        DataLoader().getNearbyWildPoints(request: request) { (result) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ARSessionVC") as! ARSessionViewController
            vc.wildPoints = result.wildpoints
            print(result.wildpoints.count)
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            guard let latitude = locations.last?.coordinate.latitude else { return }
            guard let longitude = locations.last?.coordinate.longitude else { return }
            
            userPositionMarker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
}

extension GMSMarker {
    func setIconSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
}
