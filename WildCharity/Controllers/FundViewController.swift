//
//  FundViewController.swift
//  WildCharity
//
//  Created by Egor on 28/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit
import CoreLocation

class FundViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var informationLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var donateButton: UIButton!
    
    public var fund: Fund!
    
    private var locationManager: CLLocationManager?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        donateButton.layer.cornerRadius = 10
        
        title = fund.name
        informationLabel.text = fund.description
        let backItem = UIBarButtonItem()
        backItem.title = fund.name
        navigationItem.backBarButtonItem = backItem
        
        setImages()
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
    }
    
    private func setImages() {
        if Reachability.isConnectedToNetwork() {
            fetchImage(url_img: fund.background_url, for: backgroundImage)
            fetchImage(url_img: fund.logo_url, for: logoImage)
        } else {
            let alert = UIAlertController(title: "Упс", message: "Отсутствует подключение к интернету", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Закрыть", style: .default){ action in
                self.viewDidLoad()
            })

            self.present(alert, animated: true)
        }
    }
    
    private func setWildPoint() {
        var localId = ""
        if let id = UserDefaultsManager.shared().getLocalId() {
            localId = id
        }
        guard let latitude = locationManager?.location?.coordinate.latitude else { return }
        guard let longitude = locationManager?.location?.coordinate.longitude else { return }
        let request = RequestCreateWildPoint(lon: longitude, lat: latitude, localId: localId)
        DataLoader().createWildPoint(request: request) { (result) in
            self.viewDidLoad()
        }
        
    }
    
    private func fetchImage(url_img: String, for view: UIImageView) {
        if let url = URL(string: url_img){
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    view.kf.setImage(with: url)
                }
            }
        }
    }
    
    @IBAction func donateButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Перевод", message: "Введите сумму перевода", preferredStyle: .alert)
        var textfield: UITextField = UITextField()
        var amountOfPay: Int = 0

        alert.addTextField { (tf) in
            textfield = tf
            tf.keyboardType = .numberPad
        }
        
        locationManager?.startUpdatingLocation()

        alert.addAction(UIAlertAction(title: "Перевести", style: .default){ action in
            amountOfPay = Int(textfield.text ?? "") ?? 0
            //TODO: Подключить яндекс кассу (SDK), заявка рассматривается 3 дня.
            /* Заглушка на время отсутствия яндекс кассы */
    
            if amountOfPay > 0 {
                if UserDefaultsManager.shared().getToken() == nil {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "SuccessDonateVC") as! SuccessDonateViewController

                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ARSessionVC") as! ARSessionViewController

                    self.present(vc, animated: true, completion: nil)
                }
                self.setWildPoint()
            }
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))

        self.present(alert, animated: true, completion: nil)
    }
    
}

extension FundViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty {
            guard let latitude = locations.last?.coordinate.latitude else { return }
            guard let longitude = locations.last?.coordinate.longitude else { return }
            
            self.locationManager?.stopUpdatingLocation()
        }
    }
}
