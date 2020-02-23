//
//  HeadingCell.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import TinyConstraints

protocol HeadingTappedDelegate: AnyObject {
    func didTappedAuthor(name: String)
    func didTappedOnOptions(entry: Entry, cell: UITableViewCell)
}

final class HeadingCell: UITableViewCell {
    
    weak var delegate: HeadingTappedDelegate?
    weak var entry: Entry?
    
    lazy var insetView: UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var contentTextView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.dataDetectorTypes = [.link]
        tv.isEditable = false
        return tv
    }()
    
    lazy var dateButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.numberOfLines = 0
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .light)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.contentHorizontalAlignment = .right
        return btn
    }()
    
    lazy var authorButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.contentHorizontalAlignment = .right
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        btn.addTarget(self, action: #selector(didTapAuthorButton), for: .touchUpInside)
        btn.setTitleColor(R.color.themeMain(), for: .normal)
        btn.titleLabel?.numberOfLines = 0
        return btn
    }()
    
    lazy var favoriteCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.text = "0 favori"
        return lbl
    }()
    
    lazy var optionButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        btn.setTitle(String.fontAwesomeIcon(name: .ellipsisH), for: .normal)
        btn.addTarget(self, action: #selector(didTapOnOptions), for: .touchUpInside)
        btn.setTitleColor(R.color.themeMain(), for: .normal)
        return btn
    }()
    
    lazy var bottomStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [favoriteCountLabel, authorButton])
        sv.axis = .horizontal
        sv.spacing = 4
        sv.distribution = .fillEqually
        return sv
    }()
    
    lazy var infoStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [dateButton, bottomStackView, optionButton])
        sv.axis = .vertical
        sv.distribution = .fill
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
        contentView.addSubview(insetView)
        insetView.edgesToSuperview(insets: TinyEdgeInsets(top: 5, left: 10, bottom: 5, right: 10), usingSafeArea: true)
        
        insetView.addSubview(contentTextView)
        insetView.addSubview(infoStackView)
        
        infoStackView.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), usingSafeArea: true)
        
        contentTextView.edgesToSuperview(excluding: .bottom, insets: TinyEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), usingSafeArea: true)
        contentTextView.bottomToTop(of: infoStackView, offset: -10)
        
        insetView.layer.cornerRadius = 8
        insetView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? R.color.darkGray() : .white
        contentTextView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? R.color.darkGray() : .white
        
        selectionStyle = .none
    }
    
    func setupWith(entry: Entry) {
        self.entry = entry
        contentTextView.attributedText = entry.content
        authorButton.setTitle(entry.author, for: .normal)
        dateButton.setTitle(entry.date, for: .normal)
        favoriteCountLabel.text = entry.favoritesCount + " favori"
        if entry.isFavorited {
            favoriteCountLabel.textColor = R.color.themeMain()
        } else {
            favoriteCountLabel.textColor = nil
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        insetView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? R.color.darkGray() : .white
        contentView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
        contentTextView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? R.color.darkGray() : .white
    }
    
    @objc func didTapAuthorButton() {
        if let authorName = authorButton.titleLabel?.text {
            self.delegate?.didTappedAuthor(name: authorName)
        }
    }
    
    @objc func didTapOnOptions() {
        guard let entry = entry else { return }
        self.delegate?.didTappedOnOptions(entry: entry, cell: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
