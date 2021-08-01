//
//  DownloadsPresenter.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//

import Foundation

// MARK: Object

class DownloadsPresenter: DownloadsPresenterProtocol {
    
    var view: DownloadsViewProtocol?
    var router: DownloadsRouterProtocol?
    var interactor: DownloadsInteractorProtocol?  {
        didSet {
            interactor?.updateData()
        }
    }
    
    // MARK: viper presenter protocol conformance
    
    func interactorUpdatedData(_ data: [DownloadsEntity]) {
        view?.loadAndApplyData(data)
    }
    
    func viewButtonPressedclear() {
        interactor?.clear()
    }
    
}
