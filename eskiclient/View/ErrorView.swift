//
//  ErrorView.swift
//  eskiclient
//
//  Created by Onur Geneş on 10.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import TinyConstraints
import SwiftEntryKit

final class ErrorView: UIView {
    
    lazy var errorLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "hata..."
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.font = UIFont.preferredFont(forTextStyle: .title2)
        return lbl
    }()
    
    lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    convenience init(message: String) {
        self.init(frame: .zero)
        
        descriptionLabel.text = message
        
        addSubview(errorLabel)
        addSubview(descriptionLabel)
        
        errorLabel.edgesToSuperview(excluding: .bottom, insets: TinyEdgeInsets(top: 20, left: 10, bottom: 0, right: 10), usingSafeArea: true)
        descriptionLabel.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 0, left: 10, bottom: 20, right: 10), usingSafeArea: true)
        errorLabel.bottomToTop(of: descriptionLabel, offset: -10)
    }
}
