//
//  LoginView.swift
//  eskiclient
//
//  Created by Onur Geneş on 16.09.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import TinyConstraints
import WebKit

final class LoginView: UIView {
    
    lazy var webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let wv = WKWebView(frame: .zero, configuration: config)
        return wv
    }()
    
    convenience init() {
        self.init(frame: .zero)
        
        addSubview(webView)
        
        webView.edgesToSuperview()
    }
}
