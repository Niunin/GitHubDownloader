//
//  DownloadsRouter.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//

import UIKit

typealias DownloadsEntryPoint = DownloadsViewProtocol & UIViewController

class DownloadsRouter: DownloadsRouterProtocol {
    
    weak var entry: DownloadsEntryPoint!
    
    // MARK: build
    
    static func build () -> DownloadsEntryPoint {
        let router = DownloadsRouter()
        let view = DownloadsViewController()
        let presenter = DownloadsPresenter()
        let interactor = DownloadsInteractor()
        
        view.presenter = presenter
        
        router.entry = view as DownloadsEntryPoint
        
        interactor.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        return view
    }
    
    // MARK: viper router protocol conformance
    
}
