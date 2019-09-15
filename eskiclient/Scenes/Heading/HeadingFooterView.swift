//
//  HeadingFooterView.swift
//  eskiclient
//
//  Created by Onur Geneş on 14.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import TinyConstraints
import FontAwesome_swift

final class HeadingFooterView: UIView {
    
    lazy var nextPageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.fontAwesome(forTextStyle: UIFont.TextStyle.body, style: .solid)
        btn.setTitle(String.fontAwesomeIcon(name: .chevronRight), for: .normal)
        return btn
    }()
    
    lazy var currentPageNumberLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        return lbl
    }()
    
    lazy var previousPageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.fontAwesome(forTextStyle: UIFont.TextStyle.body, style: .solid)
        btn.setTitle(String.fontAwesomeIcon(name: .chevronLeft), for: .normal)
        return btn
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [previousPageButton, currentPageNumberLabel, nextPageButton])
        sv.axis = .horizontal
        sv.distribution = .equalCentering
        return sv
    }()
    
    convenience init() {
        self.init(frame: .zero)
        
        addSubview(stackView)
        
        stackView.edgesToSuperview(insets: TinyEdgeInsets(top: 0, left: 20, bottom: 0, right: 20), usingSafeArea: true)
    }
}
