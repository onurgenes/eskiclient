//
//  OutsideLinkView.swift
//  eskiclient
//
//  Created by Onur Geneş on 26.12.2019.
//  Copyright © 2019 Onur Geneş. All rights reserved.
//

import UIKit
import WebKit
import TinyConstraints

final class OutsideLinkView: UIView {
    
    lazy var progressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .default)
        pv.tintColor = R.color.themeMain()
        return pv
    }()
    
    lazy var webView: WKWebView = {
        let wv = WKWebView()
        return wv
    }()
    
    convenience init() {
        self.init(frame: .zero)
        
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        
        addSubview(progressView)
        addSubview(webView)
        
        progressView.edgesToSuperview(excluding: .bottom, usingSafeArea: true)
        progressView.sizeToFit()
        
        webView.edgesToSuperview(excluding: .top, usingSafeArea: true)
        webView.topToBottom(of: progressView)
    }
}
