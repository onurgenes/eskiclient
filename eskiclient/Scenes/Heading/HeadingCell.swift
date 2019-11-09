//
//  HeadingCell.swift
//  eskiclient
//
//  Created by Onur Geneş on 8.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import TinyConstraints

final class HeadingCell: UITableViewCell {
    
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
        return btn
    }()
    
    lazy var favoriteCountLabel: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.text = "0 favori"
        return lbl
    }()
    
    lazy var bottomStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [favoriteCountLabel, authorButton])
        sv.axis = .horizontal
        sv.spacing = 4
        return sv
    }()
    
    lazy var infoStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [dateButton, bottomStackView])
        sv.axis = .vertical
        sv.distribution = .fill
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(contentTextView)
        addSubview(infoStackView)
        
        infoStackView.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), usingSafeArea: true)
        
        contentTextView.edgesToSuperview(excluding: .bottom, insets: TinyEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), usingSafeArea: true)
        contentTextView.bottomToTop(of: infoStackView, offset: -10)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
