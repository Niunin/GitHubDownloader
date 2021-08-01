//
//  GlancePresenter.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//

import Foundation

// MARK: Object

class SearchPresenter: SearchPresenterProtocol {

    var view: SearchViewProtocol?
    var router: SearchRouterProtocol?
    var interactor: SearchInteractorProtocol?
    
    // MARK: viper presenter protocol conformance
    
    func viewButtonPressedDownloads() {
        router?.showDownloadsScreen()
    }
    
    func viewRequested(linkTappedForCellAt index: Int) {
        interactor?.implement(downloadForCellWith: index)
    }
    
    func viewRequested(newSearchWith query: String?) {
        interactor?.implement(searchWith: query)
    }
    
    func interactorUpdated(data: [SearchEntity]) {
        view?.loadAndApplyData(data)
    }
    
}
