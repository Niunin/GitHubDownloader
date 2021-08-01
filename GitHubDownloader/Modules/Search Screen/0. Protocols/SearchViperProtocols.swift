//
//  SearchViperProtocols.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//

import Foundation


import Foundation

// MARK: - Router Protocol

protocol  SearchRouterProtocol: AnyObject  {
    
    var entry: SearchEntryPoint! { get }
    
    static func build() -> SearchEntryPoint
    
    func showDownloadsScreen()
    
}

// MARK: - View Protocol

protocol SearchViewProtocol: AnyObject {
    
    var presenter: SearchPresenterProtocol! { get set }
    
    var catalog: [SearchEntity] { get set }
    
    func loadAndApplyData(_: [SearchEntity])
    
}

// MARK: - Presenter Protocol

protocol SearchPresenterProtocol: AnyObject {
    
    var view: SearchViewProtocol? { get set }
    var router: SearchRouterProtocol? { get set }
    var interactor: SearchInteractorProtocol? { get set }
    
    func viewButtonPressedDownloads()
    func viewRequested(linkTappedForCellAt: Int)
    func viewRequested(newSearchWith: String?)
    func interactorUpdated(data: [SearchEntity])
    
}

// MARK: - Interactor Protocol

protocol SearchInteractorProtocol: AnyObject {

    var presenter: SearchPresenterProtocol! { get set }
    var dataManager: SearchDataManagerProtocol! { get set }

    func implement(searchWith query: String?)
    func implement(downloadForCellWith index: Int)

}

// MARK: - DataManager Protocol

protocol SearchDataManagerProtocol: AnyObject {
}
