//
//  SignInViewController.swift
//  WildCharity
//
//  Created by Egor on 28/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit
import CoreLocation

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    private var locationManager: CLLocationManager?
    private var wildPoints: [WildPoint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        signInButton.layer.cornerRadius = 10
        
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

    @IBAction func signInButtonTapped(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if DataValidation().validateEmail(email: email) && DataValidation().validatePassword(pass: password) {
            let request = RequestSignIn(email: email, password: password)

            DataLoader().signIn(request: request) { (result) in
                if result.user.idToken == "wrong credentials" {
                    let alert = UIAlertController(title: "Упс", message: "При входу что-то пошло не так", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Закрыть", style: .default))

                    self.present(alert, animated: true)
                } else {
                    UserDefaultsManager.shared().setToken(result.user.idToken)
                    //self.navigationController?.popToRootViewController(animated: true)
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
        } else {
            let alert = UIAlertController(title: "Упс", message: "Проверьте корректность введенных данных", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Закрыть", style: .default))

            self.present(alert, animated: true)
        }
    }

}

extension SignInViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            guard let latitude = locations.last?.coordinate.latitude else { return }
            guard let longitude = locations.last?.coordinate.longitude else { return }
            
        }
    }
}
