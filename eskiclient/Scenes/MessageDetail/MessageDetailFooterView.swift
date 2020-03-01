//
//  MessageDetailFooterView.swift
//  eskiclient
//
//  Created by Onur Geneş on 1.03.2020.
//  Copyright © 2020 Onur Geneş. All rights reserved.
//

import UIKit
import TinyConstraints

final class MessageDetailFooterView: UIView {
    
    private let buttonHeight: CGFloat = 60
    
    lazy var messageTextView: UITextView = {
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
        btn.layer.cornerRadius = buttonHeight / 2
        return btn
    }()
    convenience init() {
        self.init(frame: .zero)
        
        addSubview(messageTextView)
        addSubview(sendButton)
        
        sendButton.edgesToSuperview(excluding: .top, insets: TinyEdgeInsets(top: 0, left: 30, bottom: 10, right: 30), usingSafeArea: true)
        sendButton.height(buttonHeight)
        
        messageTextView.edgesToSuperview(excluding: .bottom, insets: TinyEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), usingSafeArea: true)
        messageTextView.bottomToTop(of: sendButton, offset: -10)
    }
}
