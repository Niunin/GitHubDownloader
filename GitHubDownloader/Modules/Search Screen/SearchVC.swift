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
        setupNavigationController()
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

private extension SearchViewController {
    // MARK: setup views
    
    func setupTableView() {
        tableView.register(SearchCell.self, forCellReuseIdentifier: SearchCell.reuseIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = UIColor.white
        tableView.tableFooterView = UIView()
    }
    
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
    
}

// MARK: - UICollectionView DataSource

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

// MARK: - UICollectionView Delegate

extension SearchViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presenter.viewRequested(linkTappedForCellAt: indexPath)
    }
    
}

// MARK: - UISearchBar Delegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        presenter.viewRequested(newSearchWith: searchBar.text)
        searchController.dismiss(animated: true, completion: nil)

        searchBar.resignFirstResponder()
        return true
    }
    
}
