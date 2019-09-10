//
//  HomeCell.swift
//  eskiclient
//
//  Created by Onur Geneş on 10.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import TinyConstraints

final class HomeCell: UITableViewCell {
    
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
        
        addSubview(stackView)
        countLabel.width(50, relation: .equalOrLess, isActive: true)
        stackView.edgesToSuperview(insets: TinyEdgeInsets(top: 10, left: 10, bottom: 10, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
