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
    
    lazy var contentTextView: CustomTextView = {
        let tv = CustomTextView()
        tv.isScrollEnabled = false
        tv.dataDetectorTypes = [.link]
        tv.isEditable = false
        return tv
    }()
    
    lazy var authorButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.contentHorizontalAlignment = .right
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return btn
    }()
    
    lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .light)
        lbl.textAlignment = .right
        return lbl
    }()
    
    lazy var infoStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [dateLabel, authorButton])
        sv.axis = .vertical
        sv.spacing = 2
        sv.distribution = .fill
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        addSubview(contentTextView)
        addSubview(infoStackView)
        
        infoStackView.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        
        contentTextView.edgesToSuperview(excluding: .bottom, insets: TinyEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))
        contentTextView.bottomToTop(of: infoStackView, offset: -10)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
