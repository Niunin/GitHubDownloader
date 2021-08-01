//
//  ViewController.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//

import UIKit

// MARK: - Object

class SearchViewController: UITableViewController, SearchViewProtocol {

    // MARK: properties
    
    var presenter: SearchPresenterProtocol!
    
    // views
    private let searchController = UISearchController(searchResultsController: nil)
        
    var catalog: [SearchEntity] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            setupNavigationController()
        } else {
            setupNavigationControllerOld()
        }
        setupTableView()
    }
    
    // MARK: viper view protocol conformance

    func loadAndApplyData(_ data: [SearchEntity]) {
        catalog = data
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchController.searchBar.becomeFirstResponder()
    }

}

// MARK: - Setup Views

private extension SearchViewController {
    
    func setupTableView() {
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.reuseIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
    
    @available(iOS 13.0, *)
    func setupNavigationController() {
        self.navigationController?.navigationBar.tintColor = UIColor.white
    
        navigationItem.searchController = searchController
        searchController.automaticallyShowsCancelButton = false
        navigationItem.searchController?.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let image = UIImage(systemName: "clock")
        
        let navBarItem = UIBarButtonItem(image: image, style: .plain , target: self, action: #selector(showDownloads))
        navBarItem.tintColor = .systemBlue
        
        navigationItem.rightBarButtonItems = [navBarItem]
    }
    
    @IBAction private func showDownloads(){
        presenter.viewButtonPressedDownloads()
    }
    
    func setupNavigationControllerOld () {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        
        let navBarItem = UIBarButtonItem(title: "saved", style: .plain , target: self, action: #selector(showDownloads))
        navBarItem.tintColor = .systemBlue

        navigationItem.rightBarButtonItems = [navBarItem]
    }
    
}

// MARK: - UITableView DataSource

extension SearchViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catalog.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.reuseIdentifier, for: indexPath) as! SearchCell
        cell.configure(cell, model: catalog[indexPath.row])
        cell.downloadButton.tag = indexPath.row
        cell.downloadButton.addTarget(self, action: #selector(downloadButtonAction(_:)), for: .touchUpInside)
        return cell
    }
    
    @IBAction func downloadButtonAction(_ sender: UIButton) {
        presenter.viewRequested(linkTappedForCellAt: sender.tag)
        // TODO: Remove it
        sender.isEnabled = false
    }
    
}

// MARK: - UISearchBar Delegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        presenter.viewRequested(newSearchWith: searchBar.text)
        if #available(iOS 13.0, *) {
            searchController.dismiss(animated: true, completion: nil)
        }
        return true
    }
    
}
