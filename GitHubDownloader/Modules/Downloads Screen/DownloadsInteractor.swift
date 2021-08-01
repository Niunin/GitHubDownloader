//
//  DownloadsInteractor.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//

import Foundation

// MARK: Object

class DownloadsInteractor: DownloadsInteractorProtocol {
    
    var dataManager: DownloadsDataManagerProtocol!
    var presenter: DownloadsPresenterProtocol!
    
    var downloaded: [DownloadsEntity] = []

    // MARK: viper interactor protocol conformance
    
    func updateData()  {
        guard let data = UserDefaults.standard.value(forKey:"Downloaded") as? Data else { return}
        guard let array = try? PropertyListDecoder().decode(Array<SearchEntity>.self, from: data) else {return}
        
        downloaded = array.map{ DownloadsEntity($0) }
        presenter.interactorUpdatedData(downloaded)
    }
    
    func clear() {
        downloaded = []
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.downloaded), forKey: "Downloaded")
        presenter.interactorUpdatedData(downloaded)
    }
    
}


