//
//  MessageCell.swift
//  eskiclient
//
//  Created by Onur Geneş on 22.02.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import UIKit
import TinyConstraints

final class MessageCell: UITableViewCell {
    
    lazy var insetView: UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var usernameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .headline)
        return lbl
    }()
    
    lazy var contentLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .footnote)
        lbl.textAlignment = .right
        return lbl
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [usernameLabel, contentLabel, dateLabel])
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
        
        contentView.addSubview(insetView)
        insetView.edgesToSuperview(insets: TinyEdgeInsets(top: 5, left: 10, bottom: 5, right: 10), usingSafeArea: true)
        
        insetView.addSubview(stackView)
        
        stackView.edgesToSuperview(insets: TinyEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), usingSafeArea: true)
        
        insetView.layer.cornerRadius = 8
        insetView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? R.color.darkGray() : .white
        
        selectionStyle = .none
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        insetView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? R.color.darkGray() : .white
        contentView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
