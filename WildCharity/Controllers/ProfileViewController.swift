//
//  ProfileViewController.swift
//  WildCharity
//
//  Created by Egor on 29/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userAccountLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var signInStackView: UIStackView!
    
    @IBOutlet weak var signOutButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var signInButton: UIButton!
    private var merchList: [Merch] = []
    private var userInfo: User?
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
        downloadMerch()
        collectionView.reloadData()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        signInButton.layer.cornerRadius = 10
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func changeProfileVisibility(hide: Bool) {
        userAccountLabel.isHidden = hide
        userNameLabel.isHidden = hide
        collectionView.isHidden = hide
        signOutButton.isHidden = hide
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaultsManager.shared().getToken() == nil {
            signInStackView.isHidden = false
            changeProfileVisibility(hide: true)
        } else {
            changeProfileVisibility(hide: false)
            signInStackView.isHidden = true
            if let local_id = UserDefaultsManager.shared().getLocalId() {
                let request = RequestProfile(localId: local_id)
                DataLoader().getProfile(request: request) { (result) in
                    self.userInfo = result.user
                    self.userNameLabel.text = self.userInfo?.name
                    self.userAccountLabel.text = "Ваши бонусы: \(self.userInfo?.account ?? 0)"
                }
            } else {
                signInStackView.isHidden = false
                changeProfileVisibility(hide: true)
            }
        }
    }
    
    func downloadMerch() {
        //TODO: Получать мерч из БД
        merchList.append(Merch(image: UIImage(named: "backpack"), price: 500))
        merchList.append(Merch(image: UIImage(named: "tiger"), price: 1000))
        merchList.append(Merch(image: UIImage(named: "panda"), price: 2000))
        merchList.append(Merch(image: UIImage(named: "shopper"), price: 250))
    }

    @IBAction func signOutButtonTapped(_ sender: Any) {
        UserDefaultsManager.shared().setToken(nil)
        UserDefaultsManager.shared().setLocalId(nil)
        tabBarController?.selectedIndex = 0
    }
    @IBAction func signUpButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
        vc.loadFromProfile()
        
        self.present(vc, animated: true, completion: nil)
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
                    UserDefaultsManager.shared().setLocalId(result.user.local_id)
                    UserDefaultsManager.shared().setToken(result.user.idToken)
                    self.viewDidLoad()
                    self.viewWillAppear(true)
                    self.dismissKeyboard()
                }
            }
        } else {
            let alert = UIAlertController(title: "Упс", message: "Проверьте корректность введенных данных", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Закрыть", style: .default))

            self.present(alert, animated: true)
        }
    }
}

extension ProfileViewController: UICollectionViewDelegate {
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = userInfo else { return }
        
        if user.account < merchList[indexPath.row].price {
            let alert = UIAlertController(title: "Упс", message: "Недостаточно бонусных баллов", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Закрыть", style: .default){ action in
            })

            self.present(alert, animated: true)
        } else {

            let alert = UIAlertController(title: "Получить", message: "Хотите приобрести? Будет списано \(merchList[indexPath.row].price) баллов.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel){ action in
            })
            alert.addAction(UIAlertAction(title: "Приобрести", style: .default){ action in
                self.viewDidLoad()
            })
            
            self.present(alert, animated: true)
        }
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MerchCell", for: indexPath) as! MerchCollectionViewCell
        cell.setupCell(merch: merchList[indexPath.row])
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return merchList.count
    }
}
