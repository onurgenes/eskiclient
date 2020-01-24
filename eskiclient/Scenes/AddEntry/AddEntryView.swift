//
//  AddEntryView.swift
//  eskiclient
//
//  Created by Onur Geneş on 21.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import TinyConstraints

final class AddEntryView: UIView {
    
    lazy var entryTextView: UITextView = {
        let tv = UITextView()
        tv.layer.borderColor = UIColor.gray.cgColor
        tv.layer.cornerRadius = 5
        tv.layer.borderWidth = 1
        return tv
    }()
    
    lazy var sendButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("gönder", for: .normal)
        btn.backgroundColor = R.color.themeMain()
        btn.setTitleColor(.white, for: .normal)
        btn.layer.borderColor = UIColor.gray.cgColor
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        return btn
    }()
    
    convenience init() {
        self.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(entryTextView)
        addSubview(sendButton)
        
        sendButton.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), usingSafeArea: true)
        sendButton.height(60)
        
        entryTextView.edgesToSuperview(excluding: .bottom, insets: TinyEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), usingSafeArea: true)
        entryTextView.bottomToTop(of: sendButton, offset: -10)
    }
}
