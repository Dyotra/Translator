//
//  HistoryViewController.swift
//  dictionary
//
//  Created by Bekpayev Dias on 19.08.2023.
//

import Foundation
import UIKit

class HistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var history: [[String: String]] = []
    
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupScene()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let entry = history[indexPath.row]
        cell.textLabel?.text = "\(entry["word"] ?? "") - \(entry["translation"] ?? "")"
        return cell
    }
    
    func setupScene() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func backButtonTapped() {
            dismiss(animated: true, completion: nil)
        }
}
