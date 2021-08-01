//
//  DownloadsTableViewCell.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//

import UIKit

class DownloadsCell: UITableViewCell {
    static let reuseIdentifier = "downloads-table-view-cell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = .white
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
