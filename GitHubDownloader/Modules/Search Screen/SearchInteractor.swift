//
//  GlanceInteractor.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//

import Foundation

// MARK: Object

class SearchInteractor: SearchInteractorProtocol {
  
    
    
    var dataManager: SearchDataManagerProtocol!
    var presenter: SearchPresenterProtocol!
    var networkManager = NetworkService()
    
    var catalog: [SearchEntity] = []
    var downloaded: [SearchEntity] = []
    
    // MARK: viper interactor protocol conformance
    
    func implement(searchWith query: String?) {
        networkManager.requestData(withSearchQuery: query) { [weak self] jsonData, error in
            if let error = error {
                print(" FetchDataError")
            } else {
                let searchResult = self?.getSearchResults(from: jsonData)
                DispatchQueue.main.async {
                    self?.catalog = searchResult ?? []
                    // TODO: fix !
                    self?.presenter.interactorUpdated(data: self!.catalog)
                }
            }
        }
    }
    
    func implement(downloadForCellWith index: Int) {
        let name = catalog[index].fullreponame
        networkManager.requestRepoFile(repoFullName: name) { [weak self] data, error in
            if let error = error {
                print(" DT4: " + String.init(describing: error))
            } else {
                
                guard let item = self?.catalog[index] else { return }
                self?.downloaded.append(item)
                
                let defaults = UserDefaults.standard
                defaults.set(try? PropertyListEncoder().encode(self?.downloaded), forKey: "Downloaded")
            }
        }
    }
    
}

// MARK: - Execute Search

private extension SearchInteractor {
    
    private func getSearchResults(from jsonData: Data?) -> [SearchEntity] {
        let searchResultData = parseJson(jsonData)
        let searchResultModel = translateToSearchEntity(from: searchResultData)
        return searchResultModel
    }
        
    private func parseJson(_ jsonData: Data?) -> SearchNetworkModel? {
        guard let data = jsonData else { return nil }
        do {
            return try JSONDecoder().decode(SearchNetworkModel.self, from: data)
        } catch let error {
            handleCompletionError(error: error)
            return nil
        }
    }
    
    
    private func translateToSearchEntity(from data: SearchNetworkModel?) -> [SearchEntity] {
        guard let data = data else { return [] }
        return data.items.map{ SearchEntity(from: $0) }
    }
    
    private func handleCompletionError(error: Error) {
        Swift.debugPrint(" " + String(describing: error))
        
    }
    
}
