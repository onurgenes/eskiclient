//
//  ProfileCell.swift
//  eskiclient
//
//  Created by Onur Geneş on 21.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import TinyConstraints

final class ProfileCell: UITableViewCell {
    
    lazy var insetView: UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var chevronImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        return lbl
    }()
    
    lazy var countLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .right
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        return lbl
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, countLabel])
        sv.axis = .horizontal
        sv.spacing = 8
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
        contentView.addSubview(insetView)
        insetView.edgesToSuperview(insets: TinyEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), usingSafeArea: true)
        
        insetView.addSubview(stackView)
        insetView.addSubview(chevronImageView)
        
        chevronImageView.rightToSuperview(offset: -10)
        chevronImageView.width(30)
        chevronImageView.height(30)
        chevronImageView.centerYToSuperview()
        
        countLabel.width(50, relation: .equalOrLess, isActive: true)
        stackView.edgesToSuperview(excluding: .right, insets: TinyEdgeInsets(top: 10, left: 10, bottom: 10, right: 16), usingSafeArea: true)
        stackView.rightToLeft(of: chevronImageView, offset: -10)
        titleLabel.bottom(to: stackView)
        
        
        chevronImageView.image = UIImage.fontAwesomeIcon(name: .chevronRight,
                                                         style: .solid,
                                                         textColor: traitCollection.userInterfaceStyle == .dark ? .lightGray : .darkGray,
                                                         size: CGSize(width: 30, height: 30))
        
        insetView.layer.cornerRadius = 8
        insetView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? R.color.darkGray() : .white
        
        selectionStyle = .none
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        chevronImageView.image = UIImage.fontAwesomeIcon(name: .chevronRight,
                                                         style: .solid,
                                                         textColor: traitCollection.userInterfaceStyle == .dark ? .lightGray : .darkGray,
                                                         size: CGSize(width: 30, height: 30))
        insetView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? R.color.darkGray() : .white
        contentView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : R.color.lightGray()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
