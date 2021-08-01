//
//  DownloadsEntity.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//

import Foundation


// MARK: - Data Structure

struct DownloadsEntity: Codable {
    
    var id: Int
    var username: String
    var reponame: String
    
    init (_ data: SearchEntity) {
        id = data.id
        username = data.username
        reponame = data.reponame
    }

}
