//
//  SignUpViewController.swift
//  WildCharity
//
//  Created by Egor on 28/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    private var isLoadedFromProfile: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        signUpButton.layer.cornerRadius = 10
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
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "ARSessionVC") as! ARSessionViewController

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
