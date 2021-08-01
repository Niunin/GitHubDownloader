//
//  SearchNetworkModel.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//
//
import Foundation

// MARK: - JSON DataStructure

struct SearchNetworkModel: Codable {
    
    let total_count: Int
    let incomplete_results: Bool
    let items: [Item]
    
}

// MARK: - Item

struct Item: Codable {
   
    let id: Int
    
    let name, full_name: String
    let owner: Owner
    let html_url: String
    
    // MARK: Owner
    
    struct Owner: Codable {
        let login: String
        let id: Int
    }

}


