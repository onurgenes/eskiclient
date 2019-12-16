//
//  SearchCell.swift
//  eskiclient
//
//  Created by Onur Geneş on 16.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import TinyConstraints

final class SearchCell: UITableViewCell {
    
    lazy var insetView: UIView = {
        let v = UIView()
        return v
    }()
    
    lazy var typeImageView: UIImageView = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
        contentView.addSubview(insetView)
        insetView.edgesToSuperview(insets: TinyEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), usingSafeArea: true)
        
        insetView.addSubview(typeImageView)
        insetView.addSubview(titleLabel)
        
        typeImageView.leftToSuperview(offset: 10)
        typeImageView.width(30)
        typeImageView.height(30)
        typeImageView.centerYToSuperview()
        
        titleLabel.edgesToSuperview(excluding: .left, insets: TinyEdgeInsets(top: 10, left: 10, bottom: 10, right: 16), usingSafeArea: true)
        titleLabel.leftToRight(of: typeImageView, offset: 10)
        
        typeImageView.image = UIImage.fontAwesomeIcon(name: .chevronRight,
                                                      style: .solid,
                                                      textColor: traitCollection.userInterfaceStyle == .dark ? .lightGray : .darkGray,
                                                      size: CGSize(width: 30, height: 30))
        
        insetView.layer.cornerRadius = 8
        insetView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1) : .white
        
        selectionStyle = .none
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        insetView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? UIColor(red: 23/255, green: 23/255, blue: 23/255, alpha: 1) : .white
        contentView.backgroundColor = traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
