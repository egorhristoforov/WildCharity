//
//  SignUpViewController.swift
//  WildCharity
//
//  Created by Egor on 28/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit
import CoreLocation

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    private var isLoadedFromProfile: Bool = false
    private var locationManager: CLLocationManager?
    private var wildPoints: [WildPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        signUpButton.layer.cornerRadius = 10
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    public func loadFromProfile() {
        isLoadedFromProfile = true
    }

    @IBAction func signUpButtonTapped(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let name = nameTextField.text ?? ""
        
        if DataValidation().validateEmail(email: email) && DataValidation().validatePassword(pass: password) && DataValidation().validateName(name: name){
            let request = RequestSignUp(email: email, password: password, name: name)

            DataLoader().createNewUser(request: request) { (result) in
                if result.user.idToken == "user hasnt been created" {
                    let alert = UIAlertController(title: "Упс", message: "При регистрации что-то пошло не так", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Закрыть", style: .default))

                    self.present(alert, animated: true)
                } else {
                    UserDefaultsManager.shared().setToken(result.user.idToken)
                    self.navigationController?.popToRootViewController(animated: true)
                    UserDefaultsManager.shared().setLocalId(result.user.local_id)
                    if self.isLoadedFromProfile {
                        self.dismiss(animated: true, completion: nil)
                        self.tabBarController?.selectedIndex = 2
                    } else {
                        UserDefaultsManager.shared().setToken(result.user.idToken)
                        self.navigationController?.popToRootViewController(animated: true)
                        self.locationManager?.startUpdatingLocation()
                        guard let latitude = self.locationManager?.location?.coordinate.latitude else { return }
                        guard let longitude = self.locationManager?.location?.coordinate.longitude else { return }
                        let request = RequestNearbyWildPoints(lon: longitude, lat: latitude)
                        DataLoader().getNearbyWildPoints(request: request) { (result) in
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "ARSessionVC") as! ARSessionViewController
                            vc.wildPoints = result.wildpoints
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                }
            }
        } else {
            let alert = UIAlertController(title: "Упс", message: "Проверьте корректность введенных данных", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Закрыть", style: .default))

            self.present(alert, animated: true)
        }
    }
}

extension SignUpViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            guard let latitude = locations.last?.coordinate.latitude else { return }
            guard let longitude = locations.last?.coordinate.longitude else { return }
            
        }
    }
}
