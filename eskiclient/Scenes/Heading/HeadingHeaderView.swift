//
//  HeadingHeaderView.swift
//  eskiclient
//
//  Created by Onur Geneş on 14.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import TinyConstraints

final class HeadingHeaderView: UIView {
    
    lazy var showAllButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("tüm entryler", for: .normal)
        return btn
    }()
    
    convenience init() {
        self.init(frame: .zero)
        
        addSubview(showAllButton)
        
        showAllButton.edgesToSuperview(usingSafeArea: true)
    }
}
