//
//  DownloadsViperProtocols.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//

import Foundation

// MARK: - Router Protocol

protocol  DownloadsRouterProtocol: AnyObject  {
    
    var entry: DownloadsEntryPoint! { get }
    
    static func build() -> DownloadsEntryPoint
    
}

// MARK: - View Protocol

protocol DownloadsViewProtocol: AnyObject {
    
    var presenter: DownloadsPresenterProtocol! { get set }
    
    var catalog: [DownloadsEntity] { get set }
    
    func loadAndApplyData(_: [DownloadsEntity])
    
}

// MARK: - Presenter Protocol

protocol DownloadsPresenterProtocol: AnyObject {
    
    var view: DownloadsViewProtocol? { get set }
    var router: DownloadsRouterProtocol? { get set }
    var interactor: DownloadsInteractorProtocol? { get set }
    
    func viewButtonPressedclear()
    func interactorUpdatedData(_ data: [DownloadsEntity])
    
}

// MARK: - Interactor Protocol

protocol DownloadsInteractorProtocol: AnyObject {

    var presenter: DownloadsPresenterProtocol! { get set }

    func updateData()
    func clear()
    
}
