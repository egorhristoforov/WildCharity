//
//  SignInViewController.swift
//  WildCharity
//
//  Created by Egor on 28/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        signInButton.layer.cornerRadius = 10
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
                    self.navigationController?.popToRootViewController(animated: true)
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ARSessionVC") as! ARSessionViewController

                    self.present(vc, animated: true, completion: nil)
                }
            }
        } else {
            let alert = UIAlertController(title: "Упс", message: "Проверьте корректность введенных данных", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Закрыть", style: .default))

            self.present(alert, animated: true)
        }
    }

}
