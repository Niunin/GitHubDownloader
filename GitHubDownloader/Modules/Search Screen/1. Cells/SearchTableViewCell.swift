//
//  SearchTableViewCell.swift
//  GitHubDownloader
//
//  Created by Andrei Niunin on 30.07.2021.
//

import UIKit

// MARK: - Object

class SearchCell: UITableViewCell {
    
    static let reuseIdentifier = "search-table-view-cell"
    
    
    // MARK: properties
    
    // Views
    let repoNameLabel = UITextView()
    let userNameLabel = UILabel()
    let downloadButton = UIButton()
    let stackHorizontal = UIStackView()
    let stackVertical = UIStackView()
    

    // Constraints
    private lazy var repoLabelHeight = repoNameLabel.heightAnchor.constraint(equalToConstant: 0)
    let largeFont = UIFont.preferredFont(forTextStyle: .title3 )
    
    // MARK: init - deinit
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func prepareForReuse() {
        downloadButton.tintColor = UIColor.systemBlue
    }
    
    // MARK: conigure
    
    func configure(_ cell: SearchCell, model: SearchEntity) {
        userNameLabel.text = model.username
        let title = model.reponame
        let link = model.link
        let fullRange = NSRange(location: 0, length: title.count)
        
        
        let repoLink = NSMutableAttributedString(string: title)
        repoLink.addAttribute(.link, value: link, range: fullRange)
        repoLink.addAttribute(.font, value: largeFont, range: fullRange)
        repoLink.addAttribute(.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: fullRange)
        
        repoNameLabel.attributedText = repoLink
        repoLabelHeight.constant = largeFont.lineHeight+13
    }
    
}

// MARK: - Setup Views

private extension SearchCell {
    
    func setupViews() {
        setupSelf()
        setupStackHorizontal(stackHorizontal)
        setupStackVertical(stackVertical)
        setupButton(downloadButton)
        setupRepoNameLabel(repoNameLabel)
        setupUserNameLabel(userNameLabel)
        setupConstraints()
    }
    
    func setupSelf() {
        contentView.addSubview(stackHorizontal)
        contentView.backgroundColor = UIColor.white
    }

    func setupStackHorizontal(_ stack: UIStackView) {
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        stack.distribution = .fill
        stack.addArrangedSubview(stackVertical)
        stack.addArrangedSubview(downloadButton)
    }

    func setupStackVertical(_ stack: UIStackView) {
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .leading
        stack.distribution = .fill
        
        stack.addArrangedSubview(repoNameLabel)
        stack.addArrangedSubview(userNameLabel)
    }
    
    func setupRepoNameLabel(_ textView: UITextView) {
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.textContainer.maximumNumberOfLines = 1
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0.0
    }
    
    func setupUserNameLabel(_ label: UILabel) {
        label.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    func setupButton(_ button: UIButton) {
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "icloud.and.arrow.down", withConfiguration: configuration)!

        button.setImage(image, for: .normal)
        button.tintColor = UIColor.systemBlue
    }
        
    func setupConstraints() {
        stackHorizontal.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        let mg = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            stackHorizontal.topAnchor.constraint(equalTo: mg.topAnchor),
            stackHorizontal.leadingAnchor.constraint(equalTo: mg.leadingAnchor),
            stackHorizontal.trailingAnchor.constraint(equalTo: mg.trailingAnchor),

            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.widthAnchor.constraint(equalToConstant: 40),
            
            mg.bottomAnchor.constraint(equalToSystemSpacingBelow: stackHorizontal.bottomAnchor, multiplier: 1)
        ])
    }
    
}

// MARK: - extension

extension SearchCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
    
}
