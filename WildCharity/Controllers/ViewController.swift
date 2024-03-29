//
//  ViewController.swift
//  WildCharity
//
//  Created by Egor on 27/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(ViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        
        return refreshControl
    }()
    private var funds: [Fund] = []
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        downloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.addSubview(self.refreshControl)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        downloadData()
        refreshControl.endRefreshing()
    }
    
    private func downloadData() {
        if Reachability.isConnectedToNetwork() {
            DataLoader().getFunds(completion: { (responsefunds) in
                self.funds = responsefunds.fonds
                self.tableView.reloadData()
            })
            
            
        } else {
            let alert = UIAlertController(title: "Упс", message: "Отсутствует подключение к интернету", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Закрыть", style: .default){ action in
                self.viewDidLoad()
            })

            self.present(alert, animated: true)
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return funds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FundCell", for: indexPath) as! FundCell
        cell.setupCell(fund: funds[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "FundVC") as! FundViewController
        vc.fund = funds[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
