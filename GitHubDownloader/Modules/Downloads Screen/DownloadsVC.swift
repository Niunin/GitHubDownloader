//
//  DownloadsVC.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//

import UIKit

// MARK: - Object

class DownloadsViewController: UITableViewController, DownloadsViewProtocol {
    
    // MARK: properties
    
    var presenter: DownloadsPresenterProtocol!
    
    var catalog: [DownloadsEntity] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationController()
        setupTableView()
    }
    
    // MARK: viper view protocol conformance

    func loadAndApplyData(_ data: [DownloadsEntity]) {
        catalog = data
    }
    
}

// MARK: - Setup Views

private extension DownloadsViewController {
    
    func setupTableView() {
        tableView.register(DownloadsCell.self, forCellReuseIdentifier: DownloadsCell.reuseIdentifier)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
    }
    
    func setupNavigationController() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let navBarItem = UIBarButtonItem(title: "Clear", style: .plain , target: self, action: #selector(clear))
        navBarItem.tintColor = .systemBlue
        
        let backBarItem = UIBarButtonItem(title: "Back", style: .plain , target: self, action: #selector(dismissAction))
        backBarItem.tintColor = .systemBlue
        
        
        navigationItem.rightBarButtonItems = [navBarItem]
        navigationItem.leftBarButtonItems = [backBarItem]
    }
    
    @IBAction private func clear(){
        presenter.viewButtonPressedclear()
    }
    
    @IBAction private func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITableView DataSource

extension DownloadsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalog.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadsCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = catalog[indexPath.row].reponame
        cell.detailTextLabel?.text = catalog[indexPath.row].username
        return cell
    }
    
}
