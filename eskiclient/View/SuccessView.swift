//
//  SuccessView.swift
//  eskiclient
//
//  Created by Onur Geneş on 10.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import TinyConstraints
import SwiftEntryKit

final class HeySentView: UIView {
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.font = UIFont.preferredFont(forTextStyle: .title1)
        return lbl
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    convenience init(title: String, message: String?) {
        self.init(frame: .zero)
        
        titleLabel.text = title
        if let message = message {
            descriptionLabel.text = message
        }
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        titleLabel.edgesToSuperview(excluding: .bottom, insets: TinyEdgeInsets(top: 20, left: 10, bottom: 0, right: 10), usingSafeArea: true)
        descriptionLabel.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 0, left: 10, bottom: 20, right: 10), usingSafeArea: true)
        titleLabel.bottomToTop(of: descriptionLabel, offset: -10)
        
    }
}
