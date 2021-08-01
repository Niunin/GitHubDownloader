//
//  GlanceRouter.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//

import UIKit

typealias SearchEntryPoint = SearchViewProtocol & UIViewController

class SearchRouter: SearchRouterProtocol {
    
    weak var entry: SearchEntryPoint!
    
    // MARK: build
    
    static func build () -> SearchEntryPoint {
        let router = SearchRouter()
        let view = SearchViewController()
        let presenter = SearchPresenter()
        let interactor = SearchInteractor()
        
        view.presenter = presenter
        
        router.entry = view as SearchEntryPoint
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
        
    }
    
    // MARK: viper router protocol conformance
    
    func showDownloadsScreen() {
        let viewController = DownloadsRouter.build()
        let navigationController =  UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.topItem?.title  = "Downloads history"
        entry.present(navigationController, animated: true)
    }
    
}
