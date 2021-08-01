//
//  GlanceEntity.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//

import Foundation


// MARK: - Data Structure

struct SearchEntity: Codable {
    
    var id: Int
    var username: String
    var reponame: String
    var fullreponame: String
    var link: String
    var isDownloaded: Bool = false
    
    init(from snm: Item) {
        id = snm.id
        username = snm.owner.login
        reponame = snm.name
        fullreponame = snm.full_name
        link = snm.html_url
    }

}
